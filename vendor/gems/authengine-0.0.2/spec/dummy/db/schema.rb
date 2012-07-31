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

ActiveRecord::Schema.define(:version => 20111003074700) do

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

  create_table "controllers", :force => true do |t|
    t.string   "controller_name"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "controllers", ["controller_name"], :name => "index_controllers_on_controller_name"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "role_id",    :limit => 8, :null => false
    t.integer  "user_id",    :limit => 8, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
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
