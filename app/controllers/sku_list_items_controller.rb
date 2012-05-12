# Manages the workflow for adding and removing items from the preferred sku list
# Items may also be edited and the user returned to the sku list after edit
class SkuListItemsController < ApplicationController
  # select an item for adding to the list
  def new
  end

  def update
    item = Item.find_by_sku(params[:item][:sku])
    # sku and upc are not updated from client as they cannot be edited
    # and may contain 'undefined' or 'null' strings from javascript
    acceptable_attrs = ["description", "category_id", "count", "weight_oz", "qoh", "preferred"]
    attrs = params[:item] ? params[:item].slice(*acceptable_attrs) : params.slice(*acceptable_attrs)
    attrs["description"] = attrs["description"].titlecase if attrs["description"] # cleaning up the database, item by item!
    if item.update_attributes(attrs)
      redirect_to edit_sku_list_path
    else
      flash[:error] = item.errors.full_messages
      redirect_to edit_sku_list_item_path(item)
    end
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.includes(:limit_category)
  end

  # add a new item to the sku list
  def create
    item = Item.find(params[:item][:id])
    item.update_attribute(:preferred, true)
    redirect_to edit_sku_list_path
  end

  # remove an item from the list just by setting its preferred attribute to false
  def destroy
    item = Item.find(params[:id])
    respond_to do |format|
      format.js do # when updating an item via ajax
        item.update_attribute(:preferred, false)
        response['Content-Type'] = 'application/json' # else jquery parses an error. Don't use charset=utf-8 here either. Same jquery error.
        render :json => {:confirm => ['Item removed']}, :status => :ok
      end
    end
  end

end
