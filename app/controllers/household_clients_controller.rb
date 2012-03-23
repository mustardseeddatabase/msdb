class HouseholdClientsController < ApplicationController
  def new
    @household = Household.includes(:clients).find(params[:household_id])
    @clients = @household.clients
    @client = @household.clients.build
  end

  def create
    @household = Household.find(params[:household_id])
    @client = Client.new(params[:client])
    @client.household = @household

    if @client.headOfHousehold?
      @household.clients.each { |client| client.update_attribute(:headOfHousehold, false) }
    end

    if @client.save
      flash[:info] = "New client added to household"
      redirect_to edit_household_path(@household)
    else
      @clients = @household.clients
      @new_client_form = true # causes the 'new' page to show the hidden new client form
      #flash[:error] = @client.errors.full_messages
      render :action => :new
    end
  end

  def update
    @household = Household.find(params[:household_id]) unless !params[:household_id]
    @client = Client.find(params[:id])
    if @client.household == @household
      redirect_to edit_household_path(@household), :notice => "Client was already resident!"
    else
      @client.household = @household
      @client.save!
      redirect_to edit_household_path(@household), :notice => "Client added as resident"
    end
  end

  # removes client from household, but leaves client in the db
  def destroy
    @household = Household.find(params[:household_id])
    @client = Client.find(params[:id])
    if @client.update_attribute(:household_id, nil)
      flash[:info] = "#{@client.first_last_name} removed from this household"
    else
      flash[:error] = "There was a problem removing the #{@client.first_last_name} from the household"
    end
    redirect_to edit_household_path(@household)
  end

end
