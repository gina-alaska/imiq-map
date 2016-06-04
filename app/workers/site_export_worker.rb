class SiteExportWorker < ActiveJob::Base
  def perform(site_export)
    @progress = 0
    site_export.search.create_site_export
  end
end
