class CreateAuthengineTables < ActiveRecord::Migration
  def self.up
    SCHEMA_AUTO_INSERTED_HERE
    DATABASE_PREPOPULATE
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
