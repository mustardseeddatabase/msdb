class AddIndexesToSeveralTables < ActiveRecord::Migration
  def change
    add_index :actions, :action_name
    add_index :controllers, :controller_name
    add_index :users, :login
  end
end
