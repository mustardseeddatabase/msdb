class LimitCategoriesController < ApplicationController
  def index
    @limit_categories = LimitCategory.order(:name).includes(:category_thresholds)
    @limit_category = LimitCategory.new
    @category_threshold = CategoryThreshold.new
  end

  def update
    params[:limit_categories].each do |cat_params|
      LimitCategory.update(cat_params[:id],cat_params)
    end
    redirect_to limit_categories_path
  end

end
