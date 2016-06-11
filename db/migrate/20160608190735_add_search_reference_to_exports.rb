class AddSearchReferenceToExports < ActiveRecord::Migration
  def change
    add_reference :exports, :search, index: true, foreign_key: true
  end
end
