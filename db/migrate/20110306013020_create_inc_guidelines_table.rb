class CreateIncGuidelinesTable < ActiveRecord::Migration
  def self.up
    create_table "inc_guidelines" do |t|
      t.integer "household_size"
      t.integer "annual"
      t.integer "monthly"
      t.integer "biweekly"
      t.integer "weekly"
      t.timestamps
    end
  end

  def self.down
    drop_table "inc_guidelines"
  end
end
