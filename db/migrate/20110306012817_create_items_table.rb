class CreateItemsTable < ActiveRecord::Migration
  def self.up
    create_table "items" do |t|
      t.column :sku, :bigint
      t.column :upc, :bigint
      t.string "description"
      t.integer "weight_oz"
      t.string "category"
      t.integer "quantity"
      t.string "limit_category"
      t.timestamps
    end
  end

  def self.down
    drop_table "items"
  end
end
