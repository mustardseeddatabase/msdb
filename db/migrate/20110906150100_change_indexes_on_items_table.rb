class ChangeIndexesOnItemsTable < ActiveRecord::Migration
  def change
    remove_index :items, :description
    add_index :items, [:sku, :description]
  end
end
