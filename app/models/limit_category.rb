class LimitCategory < ActiveRecord::Base
  has_many :category_thresholds, :dependent => :destroy, :autosave => true
  has_many :categories, :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :category_thresholds
  has_many :items, :dependent => :destroy

  def self.to_json
    all.sort_by{|lc| [ lc.food_category ? 0 : 1, lc.name ] }.to_json(:except => [:created_at, :updated_at])
  end

  def food_category
    (categories.size == 1) && (categories[0].name == "Food")
  end
end
