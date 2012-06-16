class ItemsController < ApplicationController
  # the page on which item status can be retrieved for barcode or non-barcode items
  def show
  end

  # TODO refactor this into inventories_controller
  def update_all
    Item.match_to_inventory(Inventory.find(params[:inventory_id]))
    flash[:confirm] = "Database has been adjusted to match actual inventory"
    redirect_to inventory_path(params[:inventory_id])
  end

end
