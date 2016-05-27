class SiteExportWorker < ActiveJob::Base
  def perform(search)
    @progress = 0
    search.create_site_export
  end
end
