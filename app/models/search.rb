class Search < ActiveRecord::Base
  serialize :params, JSON

  def export_filename
    Rails.root.join('exports/sites', "sites-#{self.id}.csv")
  end

  def export_exists?
    ::File.exists?(export_filename)
  end

  def create_site_export
    imiq_api = ImiqAPI.new

    export_attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

    output = CSV.generate(headers: true) do |csv|
      csv << export_attributes
      each_page(500) do |page|
        add_sites(csv, page, export_attributes)
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

  def self.params_dump(data)
    JSON.dump(data.to_hash)
  end

  def fetch(page = 1, limit = 50)
    imiq_api = ImiqAPI.new

    SitesPager.new(imiq_api.sites(params, page, limit))
  end

  def total_sites
    @total_sites ||= fetch(1,1).total_count
  end

  def each_page(limit=50, &block)
    page = 1

    while results = fetch(page, limit)
      break if results.empty?
      yield results
      page +=1
      puts page
    end if block_given?
  end
end
