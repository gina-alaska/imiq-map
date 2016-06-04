class SiteExport < ActiveRecord::Base
  belongs_to :user
  belongs_to :search

  validates :search, presence: true
  validates :user, presence: true

  def queue_export
    SiteExportWorker.perform_later self
    update_attributes(status: 'Queued', progress: 0)
  end
end
