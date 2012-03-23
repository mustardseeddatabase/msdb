class CreateInventoriesTable < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.timestamps
    end
  end
end
