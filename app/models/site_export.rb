class SiteExport < ActiveRecord::Base
  belongs_to :user
  belongs_to :search

  validates :search, presence: true
  validates :user, presence: true

  def queue_export
    SiteExportWorker.perform_later self
    update_attributes(status: 'queued', progress: 0)
  end

  def started
    update_progress! 'started', 0
    search.create_site_export
  end

  def completed
    update_progress! 'complete', 100
  end

  def completed?
    status == 'complete'
  end

  def running?
    status == 'started'
  end

  def errored?
    status == 'error'
  end

  def download_available?
    ::File.exists?(search.export_filename)
  end

  def can_retry?
    (completed? && !download_available?) || errored?
  end

  def update_progress!(state, progress = nil)
    self.status = state
    self.progress = progress unless progress.nil?
    update_attributes(status: state)
  end

  def export_error(msg)
    update_progress! 'error'
  end
end
