class CreateDistributionsTable < ActiveRecord::Migration
  def self.up
    create_table "distributions" do |t|
      t.integer "household_id"
      t.timestamps
    end
  end

  def self.down
    drop_table "distributions"
  end
end
