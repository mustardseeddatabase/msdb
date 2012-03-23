class CreateDonatedItemsTable < ActiveRecord::Migration
  def self.up
    create_table "donated_items" do |t|
      t.integer "donation_id"
      t.integer "item_id"
      t.integer "quantity"
      t.timestamps
    end
  end

  def self.down
    drop_table "donated_items"
  end
end
