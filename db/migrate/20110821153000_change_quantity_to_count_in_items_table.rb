class ChangeQuantityToCountInItemsTable < ActiveRecord::Migration
  def self.up
    rename_column :items, :quantity, :count
  end

  def self.down
    rename_column :items, :count, :quantity
  end
end
