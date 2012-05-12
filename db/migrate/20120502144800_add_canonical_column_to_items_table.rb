class AddCanonicalColumnToItemsTable < ActiveRecord::Migration
  def change
    add_column :items, :canonical, :boolean
  end
end
