class CreateBounds < ActiveRecord::Migration
  def change
    create_table :bounds do |t|
      t.string :sw_lat
      t.string :sw_lng
      t.string :ne_lat
      t.string :ne_lng
      t.references :search, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
