class AddWorkerFeedbackFieldsToExport < ActiveRecord::Migration
  def change
    add_column :exports, :status, :string, default: 'queued'
    add_column :exports, :progress, :integer, default: 0
    add_column :exports, :message, :text
  end
end
