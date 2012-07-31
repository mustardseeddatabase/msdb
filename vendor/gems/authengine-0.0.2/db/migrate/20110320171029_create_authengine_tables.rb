class CreateAuthengineTables < ActiveRecord::Migration
  def self.up
      
    create_table "useractions", :force => true do |t|
      t.integer  "user_id"
      t.integer  "action_id"
      t.string   "type"
      t.text     "params"
      t.timestamps
    end

    create_table "user_roles", :force => true do |t|
      t.integer  "role_id",    :limit => 8, :null => false
      t.integer  "user_id",    :limit => 8, :null => false
      t.timestamps
    end

    create_table "roles", :force => true do |t|
      t.string   "name"
      t.string   "short_name"
      t.timestamps
    end

    create_table "controllers", :force => true do |t|
      t.string   "controller_name"
      t.datetime "last_modified"
      t.timestamps
    end

    create_table "action_roles", :force => true do |t|
      t.integer  "role_id",    :limit => 8
      t.integer  "action_id",  :limit => 8
      t.timestamps
    end

    create_table "actions", :force => true do |t|
      t.string   "action_name"
      t.integer  "controller_id"
      t.timestamps
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
      t.timestamps
    end

    User.reset_column_information
    user = User.create(:login => 'admin', 
                :email => 'user@example.com',
                :enabled => true,
                :firstName => 'A',
                :lastName => 'User')
    user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
    user.update_attribute(:activation_code, '9bb0db48971821563788e316b1fdd53dd99bc8ff')
    user.update_attribute(:activated_at, DateTime.new(2011,1,1))
    user.update_attribute(:crypted_password, '660030f1be7289571b0467b9195ff39471c60651')

    # in the bootstrap scenario, give the administrative user enough
    # access to be able to configure the access tables for admin and other users
    role = Role.create(:name => 'developer')
    Controller.update_table
    Action.all.each { |a| role.actions << a  }
    user.roles << role
    user.save

  end

  def self.down
    drop_table :useractions
    drop_table :user_roles
    drop_table :roles
    drop_table :controllers
    drop_table :action_roles
    drop_table :actions
    drop_table :users
  end
end
