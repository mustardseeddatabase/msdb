class AddQohColumnToItemsTable < ActiveRecord::Migration
  def self.up
    add_column :items, :qoh, :integer, :default => 0
  end

  def self.down
    remove_column :items, :qoh
  end
end
