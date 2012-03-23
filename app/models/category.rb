class Category < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :category_thresholds, :dependent => :destroy
  belongs_to :limit_category

  def self.to_json
    all(:include => :limit_category).
      sort_by{|cat| [(cat.name == "Food") ? 0 : 1, cat.descriptor]}.
      to_json( :methods => :descriptor,
               :include => {:limit_category => {:except => [:created_at, :updated_at]}},
               :except => [:created_at, :updated_at])
  end

  def descriptor
    if limit_category && (name == "Food")
      "Food: #{limit_category.name}"
    else
      name
    end
  end
end
