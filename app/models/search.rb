class Search < ActiveRecord::Base
  has_many :exports, dependent: :destroy
  has_many :site_exports, dependent: :destroy
  has_one :bound

  QUERY_PARAMS = [:q, :siteids, :datatype, :samplemedium, :generalcategory,
    :valuetype, :variablename, :networkcode, :organizationcode, :derived_values,
    :time_step, :bounds]

  def export_filename
    Rails.root.join('exports/sites', "sites-#{self.id}.csv")
  end

  def export_exists?
    ::File.exists?(export_filename)
  end

  def create_site_export(&block)
    imiq_api = ImiqAPI.new

    export_attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

    output = CSV.generate(headers: true) do |csv|
      csv << export_attributes
      each_page(500) do |data, page|
        yield data.offset_value, total_sites if block_given?
        add_sites(csv, data, export_attributes)
      end
    end

    FileUtils.mkdir_p(File.dirname(export_filename))
    File.write(export_filename, output)
  end

  def add_sites(csv, pager, attributes)
    pager.each do |site|
      csv << attributes.map{ |attr| site.send(attr) }
    end
  end

  def fetch(page = 1, limit = 50)
    imiq_api = ImiqAPI.new

    SitesPager.new(imiq_api.sites(imiq_api_params, page, limit))
  end

  def total_sites
    @total_sites ||= fetch(1,1).total_count
  end

  def self.first_or_create_with_search(search)
    bounds = search.delete('bounds')
    s = where(search)

    s = s.includes(:bound).where(bounds: bounds).references(:bound) unless bounds.nil?

    s.first_or_create do |search|
      search.build_bound(bounds) unless bounds.nil?
    end
  end

  def imiq_api_params
    as_json(only: Search::QUERY_PARAMS, method: :bounds)
  end

  def bounds
    bound.as_json(only: [:sw_lat, :sw_lng, :ne_lat, :ne_lng])
  end

  def each_page(limit=50, &block)
    page = 1

    while results = fetch(page, limit)
      break if results.empty?
      yield results, page
      page +=1
    end if block_given?
  end
end
