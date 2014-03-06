class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.text :sites
      t.string :uuid
      t.date :starts_at
      t.date :ends_at
      t.string :email
      t.integer :user_id
      t.string :timestep
      t.text :variables

      t.timestamps
    end
  end
end
