class CreateDistributionItemsTable < ActiveRecord::Migration
  def self.up
    create_table "distribution_items" do |t|
      t.integer "distribution_id"
      t.integer "item_id"
      t.integer "quantity"
      t.timestamps
    end
  end

  def self.down
    drop_table "distribution_items"
  end
end
