class CreateLimitsTable < ActiveRecord::Migration
  def self.up
    create_table "limits" do |t|
      t.string "category"
      t.integer "one_resident"
      t.integer "two_residents"
      t.integer "three_residents"
      t.integer "four_residents"
      t.integer "five_residents"
      t.integer "six_residents"
      t.timestamps
    end
  end

  def self.down
    drop_table "limits"
  end
end
