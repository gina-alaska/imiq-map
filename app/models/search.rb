class Search < ActiveRecord::Base
  serialize :params, JSON

  def export_filename
    Rails.root.join('exports/sites', "site-export-#{self.id}.csv")
  end

  def export_exists?
    ::File.exists?(export_filename)
  end

  def create_export
    imiq_api = ImiqAPI.new

    export_attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

    output = CSV.generate(headers: true) do |csv|
      csv << export_attributes
      pager = search.fetch(1, 50)
      add_sites(csv, pager, export_attributes)

      (2..pager.total_pages).each do |page|
        pager = search.fetch(page, 50)
        add_sites(csv, pager, export_attributes)
      end
    end

    File.write(exports_filename, output)
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
end
