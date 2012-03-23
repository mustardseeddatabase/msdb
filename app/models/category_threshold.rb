class CategoryThreshold < ActiveRecord::Base
  belongs_to :limit_category

  class << self
    def thresholds_where_resident_count_is(count)
      thresholds = joins(:limit_category).
                      where('category_thresholds.res_count = ?', [6,count].min).
                      select('limit_categories.name as name, category_thresholds.threshold as value')
      thresholds.map{|t| "'#{t.name}':#{t.value}"}.join(', ')
    end
  end
end
