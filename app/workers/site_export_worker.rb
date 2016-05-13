class SiteExportWorker < ActiveJob::Base

  def perform(id)
    search = Search.find(id)
    imiq_api = ImiqAPI.new

    attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

    output = CSV.generate(headers: true) do |csv|
      csv << attributes
      pager = search.fetch(1, 50)
      add_sites(csv, pager, attributes)

      (2..pager.total_pages).each do |page|
        pager = search.fetch(page, 50)
        add_sites(csv, pager, attributes)
      end
    end
  end

  def add_sites(csv, pager, attributes)
    pager.each do |site|
      csv << attributes.map{ |attr| site.send(attr) }
    end
  end
end
