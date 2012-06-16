class AddPreferredColumnToItemsTable < ActiveRecord::Migration
  def change
    add_column :items, :preferred, :boolean
  end
end
