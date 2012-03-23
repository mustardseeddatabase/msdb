class DistributionsController < ApplicationController
  def index
  end

  def new
    @client            = Client.find(params[:client_id])
    @distribution      = Distribution.new
    @distribution_item = DistributionItem.new
  end

  def create
    household    = Client.find(params[:client_id]).household
    distribution = Distribution.new(:household_id => household.id,
                                    :cid => params[:cid],
                                    :distribution_items_attributes => params[:transaction_items_attributes])

    if distribution.save
      render :json => {:flash => {:confirm => ['Checkout completed']},
                       :transaction => distribution.cid_map,
                       :transaction_items => distribution.distribution_items_cid_map,
                       :items => distribution.item_cid_map
                       }, :status => :ok
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
