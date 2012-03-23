class AddLimitCategoryIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :limit_category_id, :integer
  end

  def self.down
    remove_column :categories, :limit_category_id
  end
end
