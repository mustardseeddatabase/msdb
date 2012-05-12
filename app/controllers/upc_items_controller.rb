class UpcItemsController < ApplicationController
  def show
    respond_to do |format|
      format.js {# when scanning a barcode, e.g. when receiving donations
        item = Item.includes(:category => :limit_category).find_or_create_by_upc(params[:upc])
        item.count = 1 if item.count == 0 # this is a convenience hack to avoid the user constantly having to fix zero-count items
        render :json => item.to_json(:methods => [:source, :category_descriptor, :category_name, :limit_category_id], :except => [:created_at, :updated_at])
      }
    end
  end

  def update
    item = Item.find_by_upc(params[:upc])
    # sku and upc are not updated from client as they cannot be edited
    # and may contain 'undefined' or 'null' strings from javascript
    acceptable_attrs = ["description", "category_id", "count", "weight_oz", "qoh", "canonical"]
    attrs = params[:item] ? params[:item].slice(*acceptable_attrs) : params.slice(*acceptable_attrs)
    attrs["description"] = attrs["description"].titlecase if attrs["description"] # cleaning up the database, item by item!
    respond_to do |format|

      format.js do # when updating an item via ajax from the item status page
        if item.update_attributes(attrs)
          render :json => {:confirm => ['Item updated']}, :status => :ok
        else
          render :json => {:error => item.errors.full_messages}, :status => :ok
        end
      end

      format.html do
        if item.update_attributes(attrs)
          redirect_to sku_list_edit_path
        else
          flash[:error] = item.errors.full_messages
          redirect_to edit_item_path(item)
        end
      end

    end
  end

end
