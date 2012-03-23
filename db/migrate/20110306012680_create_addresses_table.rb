class CreateAddressesTable < ActiveRecord::Migration
  def self.up
    create_table "addresses" do |t|
      t.string "address"
      t.string "city"
      t.string "zip"
      t.string "apt"
      t.timestamps
    end
    add_index :addresses, :city
    add_index :addresses, :zip
    add_index :addresses, :address
  end

  def self.down
    drop_table "addresses"
  end
end
