class AddParentIdToRolesTable < ActiveRecord::Migration
  def change
    add_column :roles, :parent_id, :integer, :default => nil
  end
end
