class ClientsController < ApplicationController
  def new
    @client = Client.new
    @household = Household.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:info] = "New client created"
      redirect_to client_path(@client.barcode)
    else
      flash[:error] = @client.errors.full_messages
      redirect_to new_client_path
    end
  end

  def edit
    @client = Client.find(params[:id])
    @household = @client.household
  end

  def update
    @client = Client.find(params[:barcode])
    if @client.update_attributes(params[:client])
      if @client.headOfHousehold?
        household = @client.household
        household.clients.each{|client|
          client.update_attribute(:headOfHousehold, false) unless client == @client
        }
      end
      flash[:info] = "Client updated"
      redirect_to client_path(@client.barcode)
    else
      flash[:error] = @client.errors.full_messages
      redirect_to edit_client_path(@client)
    end
  end

  def show
    @client = Client.find_by_barcode(params[:barcode])
    if @client
      @checkins = @client.checkins.sort_by(&:created_at).reverse
      @household = @client.household
      @distributions = @household.distributions
    end
    @return_to = params[:return_to]
    respond_to do |format|
      format.html
      format.js do
        render 'household_clients/show'
      end
    end
  end

  def index
    @client = Client.new
    @return_to = 'clients_path'
  end

  def autocomplete
    if params[:client_name]
      clients = Client.lastNames_matching(params[:client_name])
    else
      clients = Client.lastNames_matching_extended(params[:client_full_name])
    end
    render :text => clients.join("\n")
  end

  def destroy
    @client = Client.find(params[:id])
    @client.delete
    flash[:notice] = "Client #{@client.first_last_name} deleted"
    redirect_to eval(params[:return_to])
  end

end
