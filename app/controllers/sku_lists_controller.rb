class SkuListsController < ApplicationController
  def show
    @items = Item.preferred
    @categories = @items.map(&:category).uniq
  end

  def edit
    @items = Item.preferred
    @categories = @items.map(&:category).uniq
    @item_categories = @items.group_by(&:category_descriptor)
    @item_categories.merge!({"No category" => @item_categories[nil]}) if @categories.include?(nil)
    @item_categories.delete(nil) if @item_categories[nil]
  end

end
