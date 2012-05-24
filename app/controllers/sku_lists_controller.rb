class SkuListsController < ApplicationController
  def show
    @items = Item.includes(:category).preferred
    @categories = @items.map(&:category).uniq
    respond_to do |format|
      format.html
      format.docx { render :docx => "sku_list" }
    end
  end

  def edit
    @items = Item.includes(:category).preferred
    @categories = @items.map(&:category).uniq
    @item_categories = @items.group_by(&:category_descriptor)
    @item_categories.merge!({"No category" => @item_categories[nil]}) if @categories.include?(nil)
    @item_categories.delete(nil) if @item_categories[nil]
  end

end
