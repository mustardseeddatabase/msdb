class AddHouseholdIdAsIndexOnClients < ActiveRecord::Migration
  def self.up
    add_index :clients, :household_id
  end

  def self.down
    remove_index :clients, :household_id
  end
end
