class SkuListsController < ApplicationController
  helper :sku_categories # should no be necessary, but otherwise problems in Rails 2.3.5, test mode

  def show
    barcodes = params[:barcodes] == "true"
    @categorized_items = Item.includes(:category => :limit_category)
                             .preferred
                             .sort_by(&:description) # sort the items
                             .group_by(&:category_descriptor)

    respond_to do |format|
      format.html
      if barcodes
        format.docx { render :docx => "sku_list_barcodes", :template => "sku_lists/sku_list_barcodes.xml" }
      else
        format.docx { render :docx => "sku_list"} # renders show.docx.builder
      end
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
