class AddTypeFieldToUserRolesTable < ActiveRecord::Migration
  def change
    add_column :user_roles, :type, :string, :default => 'PersistentUserRole'
  end
end
