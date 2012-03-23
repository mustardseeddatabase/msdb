class AddIndexesToItemsTable < ActiveRecord::Migration
  def self.up
    add_index :items, :upc
    add_index :items, :description
  end

  def self.down
    remove_index :items, :upc
    remove_index :items, :description
  end
end
