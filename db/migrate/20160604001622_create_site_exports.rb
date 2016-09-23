class CreateSiteExports < ActiveRecord::Migration
  def change
    create_table :site_exports do |t|
      t.references :user, index: true, foreign_key: true
      t.references :search, index: true, foreign_key: true
      t.string :status
      t.string :progress

      t.timestamps null: false
    end
  end
end
