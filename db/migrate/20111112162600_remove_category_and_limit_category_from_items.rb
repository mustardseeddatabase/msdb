class RemoveCategoryAndLimitCategoryFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :limit_category
    remove_column :items, :category
  end
end
