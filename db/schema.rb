# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20120401061000) do
=======
ActiveRecord::Schema.define(:version => 20120502144800) do
>>>>>>> ccstb

  create_table "action_roles", :force => true do |t|
    t.integer  "role_id",    :limit => 8
    t.integer  "action_id",  :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", :force => true do |t|
    t.string   "action_name"
    t.integer  "controller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["action_name"], :name => "index_actions_on_action_name"

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "apt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "addresses", ["address"], :name => "index_addresses_on_address"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["id", "type"], :name => "index_addresses_on_id_and_type"
  add_index "addresses", ["zip"], :name => "index_addresses_on_zip"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "limit_category_id"
  end

  create_table "category_thresholds", :force => true do |t|
    t.integer  "limit_category_id"
    t.integer  "res_count"
    t.integer  "threshold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkins", :force => true do |t|
    t.integer  "client_id"
    t.integer  "parent_id"
    t.boolean  "id_warn",    :default => false
    t.boolean  "inc_warn",   :default => false
    t.boolean  "res_warn",   :default => false
    t.boolean  "gov_warn",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkins", ["client_id"], :name => "index_checkins_on_client_id"
  add_index "checkins", ["parent_id"], :name => "index_checkins_on_parent_id"

  create_table "clients", :force => true do |t|
    t.integer  "household_id"
    t.string   "firstName"
    t.string   "mi"
    t.string   "lastName"
    t.string   "suffix"
    t.date     "birthdate"
    t.string   "race"
    t.string   "gender"
    t.boolean  "headOfHousehold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["household_id"], :name => "index_clients_on_household_id"
  add_index "clients", ["lastName"], :name => "index_clients_on_lastName"

  create_table "controllers", :force => true do |t|
    t.string   "controller_name"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "controllers", ["controller_name"], :name => "index_controllers_on_controller_name"

  create_table "distributions", :force => true do |t|
    t.integer  "household_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", :force => true do |t|
    t.integer  "donor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donors", :force => true do |t|
    t.string   "organization"
    t.string   "contactName"
    t.string   "contactTitle"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "households", :force => true do |t|
    t.integer  "perm_address_id"
    t.integer  "temp_address_id"
    t.string   "phone"
    t.string   "email"
    t.integer  "income"
    t.boolean  "ssi"
    t.boolean  "medicaid"
    t.boolean  "foodstamps"
    t.boolean  "homeless"
    t.boolean  "physDisabled"
    t.boolean  "mentDisabled"
    t.boolean  "singleParent"
    t.boolean  "vegetarian"
    t.boolean  "diabetic"
    t.boolean  "retired"
    t.boolean  "unemployed"
    t.text     "otherConcerns"
    t.boolean  "usda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inc_guidelines", :force => true do |t|
    t.integer  "household_size"
    t.integer  "annual"
    t.integer  "monthly"
    t.integer  "biweekly"
    t.integer  "weekly"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "sku",               :limit => 8
    t.integer  "upc",               :limit => 8
    t.string   "description"
    t.integer  "weight_oz"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "qoh",                            :default => 0
    t.integer  "category_id"
    t.integer  "limit_category_id"
    t.boolean  "preferred"
  end

  add_index "items", ["sku", "description"], :name => "index_items_on_sku_and_description"
  add_index "items", ["upc"], :name => "index_items_on_upc"

  create_table "limit_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualification_documents", :force => true do |t|
    t.string   "type"
    t.integer  "association_id"
    t.boolean  "confirm"
    t.date     "date"
    t.integer  "warnings"
    t.boolean  "vi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "docfile"
  end

  add_index "qualification_documents", ["association_id", "type"], :name => "index_qualification_documents_on_association_id_and_type"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "transaction_items", :force => true do |t|
    t.string   "type"
    t.integer  "transaction_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "role_id",    :limit => 8, :null => false
    t.integer  "user_id",    :limit => 8, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "useractions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "action_id"
    t.string   "type"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.string   "firstName"
    t.string   "lastName"
    t.string   "type"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
