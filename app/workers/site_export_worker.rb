class SiteExportWorker < ActiveJob::Base
  def perform(site_export)
    site_export.create_export!
  end
end
