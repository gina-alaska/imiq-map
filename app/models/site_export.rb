class SiteExport < ActiveRecord::Base
  belongs_to :user
  belongs_to :search

  validates :search, presence: true
  validates :user, presence: true
  validate :at_least_one_site_found

  def at_least_one_site_found
    errors.add(:search_id, "did not include any sites") unless search.total_sites > 0
  end

  def queue_export
    SiteExportWorker.perform_later self
    update_attributes(status: 'queued', progress: 0)
  end

  def create_export!
    start

    search.create_site_export do |items, total|
      update_progress! 'exporting', (items/total.to_f*100).to_i
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
    self.save!
  end

  def export_error(msg)
    update_progress! 'error'
  end
end
