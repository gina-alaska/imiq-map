class CreateAppStatuses < ActiveRecord::Migration
  def change
    create_table :app_statuses do |t|
      t.boolean :active
      t.text :message

      t.timestamps
    end
  end
end
