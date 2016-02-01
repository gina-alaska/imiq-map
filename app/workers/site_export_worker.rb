class SiteExportWorker < ActiveJob::Base

  def perform(id)
    search = Search.find(id)
    imiq_api = ImiqAPI.new

    attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

    output = CSV.generate(headers: true) do |csv|
      csv << attributes
      pager = SitesPager.new(imiq_api.sites(search.params, 1, 50))
      add_sites(csv, pager)

      (2..pager.total_pages).each do |page|
        pager = SitesPager.new(imiq_api.sites(search.params, page, 50))
        add_sites(csv, pager)
      end
    end
  end

  def add_sites(csv, pager)
    pager.each do |site|
      csv << attributes.map{ |attr| site.send(attr) }
    end
  end
end
