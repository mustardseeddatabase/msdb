class AddClientAndHouseholdCheckins < ActiveRecord::Migration
  def change
    create_table :household_checkins do |t|
      t.integer :household_id
      t.boolean :res_warn, :default => false
      t.boolean :inc_warn, :default => false
      t.boolean :gov_warn, :default => false
      t.timestamps
    end

    create_table :client_checkins do |t|
      t.integer :client_id
      t.boolean :id_warn, :default => false
      t.boolean :primary, :default => false
      t.integer :household_checkin_id
      t.timestamps
    end
  end
end
