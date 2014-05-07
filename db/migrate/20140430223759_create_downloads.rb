class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer :export_id
      t.string :file

      t.timestamps
    end
  end
end
