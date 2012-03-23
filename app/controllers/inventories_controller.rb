class InventoriesController < ApplicationController
  def new
    @inventory = Inventory.new
  end

  def create
    inventory = Inventory.new(:cid => params[:cid],
                              :inventory_items_attributes => params[:transaction_items_attributes])
    if inventory.save
      render :json => {:flash => {:confirm => ['Inventory saved']},
                       :transaction => inventory.cid_map,
                       :transaction_items => inventory.inventory_items_cid_map,
                       :items => inventory.item_cid_map
                       }, :status => :ok
    else
      messages = ['A problem prevented the inventory from being saved.']
      messages += inventory.errors.full_messages
      messages.join('<br/>')
      render :json => {:error => messages}, :status => :ok
    end
  end

  def show
    @inventory = Inventory.find(params[:id])
  end

  def index
    @inventories = Inventory.all.sort.reverse
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    inventory = Inventory.find(params[:id])
    if inventory.update_attributes(:inventory_items_attributes => params[:transaction_items_attributes])
      render :json => {:flash => {:confirm => ['Inventory updated']},
                       :transaction => inventory.cid_map,
                       :transaction_items => inventory.inventory_items_cid_map,
                       :items => inventory.item_cid_map
                       }, :status => :ok
    else
      messages = ['A problem prevented the inventory from being saved.']
      messages += inventory.errors.full_messages
      messages.join('<br/>')
      render :json => {:error => messages}, :status => :ok
    end
  end
end
