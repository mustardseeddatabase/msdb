class AddCategoryAssociationsToItemsTable < ActiveRecord::Migration
  def change
    add_column :items, :category_id, :integer
    add_column :items, :limit_category_id, :integer
  end
end
