class SiteExportWorker < ActiveJob::Base
  def perform(site_export)
    site_export.started

    site_export.completed
  rescue
    site_export.export_error('Error!')
  end
end
