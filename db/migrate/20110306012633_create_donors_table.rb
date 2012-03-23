class CreateDonorsTable < ActiveRecord::Migration
  def self.up
    create_table "donors" do |t|
      t.string "organization"
      t.string "contactName"
      t.string "contactTitle"
      t.string "address"
      t.string "city"
      t.string "state"
      t.string "zip"
      t.string "phone"
      t.string "fax"
      t.string "email"
      t.timestamps
    end
  end

  def self.down
    drop_table "donors"
  end
end
