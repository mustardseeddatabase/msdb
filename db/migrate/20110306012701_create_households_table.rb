class CreateHouseholdsTable < ActiveRecord::Migration
  def self.up
    create_table "households" do |t|
      t.integer "perm_address_id"
      t.integer "temp_address_id"
      t.string "phone"
      t.string "email"
      t.integer "resident_count"
      t.integer "income"
      t.boolean "ssi"
      t.boolean "medicaid"
      t.boolean "foodstamps"
      t.boolean "homeless"
      t.boolean "physDisabled"
      t.boolean "mentDisabled"
      t.boolean "singleParent"
      t.boolean "vegetarian"
      t.boolean "diabetic"
      t.boolean "retired"
      t.boolean "unemployed"
      t.text "otherConcerns"
      t.boolean "resConfirm"
      t.date "resDate"
      t.integer "resWarn"
      t.boolean "resVI"
      t.boolean "incConfirm"
      t.date "incDate"
      t.integer "incWarn"
      t.boolean "incVI"
      t.boolean "govConfirm"
      t.date "govDate"
      t.integer "govWarn"
      t.boolean "govVI"
      t.boolean "usda"
      t.timestamps
    end
  end

  def self.down
    drop_table "households"
  end
end
