class AdjustParamsToJsonDataType < ActiveRecord::Migration
  def change
    Search.destroy_all
    remove_column :searches, :params, :string
    add_column :searches, :q, :string
    add_column :searches, :siteids, :string
    add_column :searches, :networkcode, :string
    add_column :searches, :organizationcode, :string
    add_column :searches, :datatype, :string
    add_column :searches, :samplemedium, :string
    add_column :searches, :generalcategory, :string
    add_column :searches, :valuetype, :string
    add_column :searches, :variablename, :string
    add_column :searches, :derived_values, :string
    add_column :searches, :time_step, :string
  end

end
