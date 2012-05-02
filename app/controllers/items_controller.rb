class ItemsController < ApplicationController
  def index
  end

  def show
    respond_to do |format|
      format.html
      format.js {# e.g. when receiving donations
        item = Item.includes(:category => :limit_category).find_or_create_by_upc(params[:upc])
        item.count = 1 if item.count == 0 # this is a convenience hack to avoid the user constantly having to fix zero-count items
        render :json => item.to_json(:methods => [:source, :category_descriptor, :category_name, :limit_category_id], :except => [:created_at, :updated_at])
      }
    end
  end

  def update
    respond_to do |format|
      format.js do # when updating an item via ajax
        item = Item.find(params[:id])
        # sku and upc are not updated from client as they cannot be edited
        # and may contain 'undefined' or 'null' strings from javascript
        acceptable_attrs = ["description", "category_id", "count", "weight_oz", "qoh"]
        attrs = Hash[params.select{|k,v| acceptable_attrs.include?(k)}]
        attrs["description"] = attrs["description"].titlecase
        if item.update_attributes(attrs)
          render :json => {:confirm => ['Item updated']}, :status => :ok
        else
          render :json => {:error => item.errors.full_messages}, :status => :ok
        end
      end
    end
  end

  def update_all
    Item.match_to_inventory(Inventory.find(params[:inventory_id]))
    flash[:confirm] = "Database has been adjusted to match actual inventory"
    redirect_to inventory_path(params[:inventory_id])
  end

  # User types in a description fragment for items without a barcode
  def autocomplete
    items = Item.with_sku.with_description(params[:description]).includes(:category)
    items << Item.new(:description => 'New Item')
    items = items.map(&:for_autocompleter)
    render :text => items.join("\n")
  end

end
