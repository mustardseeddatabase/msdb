class DistributionsController < ApplicationController
  def index
    @client = Client.new
  end

  def new
    @client            = Client.find_by_barcode(params[:barcode])
    @distribution      = Distribution.new
    @distribution_item = DistributionItem.new
  end

  def create
    client       = Client.find_by_barcode(params[:barcode])
    household    = client.household
    distribution = Distribution.new(:household_id => household.id,
                                    :pantry_id => params[:pantry_id],
                                    :cid => params[:cid],
                                    :distribution_items_attributes => params[:transaction_items_attributes])

    if distribution.save
      #render :json => {:flash => {:confirm => ['Checkout completed']},
                       #:transaction => distribution.cid_map,
                       #:transaction_items => distribution.distribution_items_cid_map,
                       #:items => distribution.item_cid_map
                       #}, :status => :ok
      flash[:confirm]= "Checkout completed for #{client.first_last_name}"
      redirect_to pantry_distributions_path(params[:pantry_id])
    else
      messages = ['A problem prevented the distribution from being saved.']
      messages += distribution.errors.full_messages
      messages.join('<br/>')
      render :json => {:error => messages}, :status => :ok
    end
  end

  def update
  end
end
