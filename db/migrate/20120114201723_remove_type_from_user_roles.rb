class RemoveTypeFromUserRoles < ActiveRecord::Migration
  def self.up
    remove_column :user_roles, :type
  end

  def self.down
    add_column :user_roles, :type, :string
  end
end
