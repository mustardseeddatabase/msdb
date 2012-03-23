class CreateClientsTable < ActiveRecord::Migration
  def self.up
    create_table "clients" do |t|
      t.integer "household_id"
      t.string "firstName"
      t.string "mi"
      t.string "lastName"
      t.string "suffix"
      t.date "birthdate"
      t.string "race"
      t.string "gender"
      t.boolean "headOfHousehold"
      t.boolean "idConfirm"
      t.datetime "idDate"
      t.integer "idWarn"
      t.boolean "idvi"
      t.timestamps
    end

    add_index :clients, :lastName
  end

  def self.down
    drop_table "clients"
  end
end
