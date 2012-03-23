class CreateLimitCategoriesAndCategoryThresholdsTables < ActiveRecord::Migration
  def change
    create_table :limit_categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :category_thresholds do |t|
      t.integer :limit_category_id
      t.integer :res_count
      t.integer :threshold
      t.timestamps
    end

    drop_table :limits
  end
end
