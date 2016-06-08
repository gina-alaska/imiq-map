class SiteExport < ActiveRecord::Base
  belongs_to :user
  belongs_to :search

  validates :search, presence: true
  validates :user, presence: true

  def queue_export
    SiteExportWorker.perform_later self
    update_attributes(status: 'queued', progress: 0)
  end

  def create_export!
    start

    search.create_site_export do |items, total|
      self.update_progress! 'exporting', items/total*100.to_i
    end

    complete
  rescue
    site_export.export_error('Error!')
  end

  def start
    update_progress! 'started', 0
  end

  def complete
    update_progress! 'completed', 100
  end

  def completed?
    status == 'completed'
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
