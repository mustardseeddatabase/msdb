class DonationsController < ApplicationController
  def index
    @donors = Donor.all.reject{|d| d.organization.nil?}
    @donations = Donation.most_recent_five
  end

  def new
    @donor = Donor.find(params[:donor_id])
    @donation = Donation.new
    @donated_item = DonatedItem.new
  end

  def edit
    @donation = Donation.find(params[:id], :include => {:donated_items => :item})
    @donated_items = @donation.donated_items
    @donor = Donor.find(params[:donor_id])
  end

  def create
    donation = Donation.new(:donor_id => params[:donor_id],
                            :cid => params[:cid],
                            :donated_items_attributes => params[:transaction_items_attributes])
    if donation.save
      render :json => {:flash => {:confirm => ['Donation saved']},
                       :transaction => donation.cid_map,
                       :transaction_items => donation.donated_items_cid_map,
                       :items => donation.item_cid_map
                       }, :status => :ok
    else
      messages = ['A problem prevented the donation from being saved.']
      messages += donation.errors.full_messages
      messages.join('<br/>')
      flash[:error] = messages
      redirect_to new_donor_donation_path(params[:donor_id])
    end
  end

  def update
    donation = Donation.find(params[:id])
    donation.cid = params[:cid]
    if donation.update_attributes(:donated_items_attributes => params[:transaction_items_attributes])
      render :json => {:flash => {:confirm => ['Donation updated']},
                       :transaction => donation.cid_map,
                       :transaction_items => donation.donated_items_cid_map,
                       :items => donation.item_cid_map
                       }, :status => :ok
    else
      messages = ['A problem prevented the donation from being saved.']
      messages += donation.errors.full_messages
      messages.join('<br/>')
      render :json => {:error => messages}, :status => :ok
    end
  end
end
