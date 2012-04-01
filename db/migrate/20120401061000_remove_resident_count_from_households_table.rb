class RemoveResidentCountFromHouseholdsTable < ActiveRecord::Migration
  def change
    remove_column :households, :resident_count
  end
end
