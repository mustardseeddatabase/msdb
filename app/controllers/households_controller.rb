class HouseholdsController < ApplicationController
  def new
    @household_search = HouseholdSearch.new({}) # no real purpose except to initialize the return path of the form
    @household = Household.new
    @household.build_perm_address
    @household.build_temp_address
    @household.build_res_qualdoc
    @household.build_inc_qualdoc
    @household.build_gov_qualdoc
    @include_clients = false
  end

  def create
    @household = Household.new(params[:household])
    if @household.save
      redirect_to households_path, :notice => "New household was saved"
    else
      flash[ :error ] = @household.errors.full_messages
      redirect_to new_household_path
    end
  end

  def edit
    @household_search = HouseholdSearch.new(params[:household_search])
    @household = Household.find(params[:id])
    @household.build_perm_address unless @household.perm_address
    @household.build_temp_address unless @household.temp_address
    @clients = @household.clients.sort_by{|c| c.age.nil? ? 0 : c.age}.reverse
    @include_clients = true
    @url = params[:checkin_id] ? checkin_household_path(params[:checkin_id], @household) : household_path(@household)
  end

  def update
    @household_search = HouseholdSearch.new(params[:index_query]) if params[:index_query] != "null" # index_query carries the search information when edit/save is invoked from search results
    @household = Household.find(params[:id])
    if @household.update_attributes(params[:household])
      flash[:notice] = 'Household was updated'
      if params[:index_query] == "null"
        if client_checkin_id = params[:checkin_id]
          checkin = Checkin.find_by_client_checkin_id(client_checkin_id)
          household_id = checkin.household.id
          redirect_to checkin_household_path(client_checkin_id, household_id)
        else
          redirect_to household_path(@household)
        end

      else
        redirect_to households_path(@household_search.to_params)
      end
    else
      flash[:error] = @household.errors.full_messages
      render :edit
    end
  end

  def show
    @household = Household.includes(:clients).find(params[:id])
    @clients = @household.clients.sort_by{|c| c.age || 0 }.reverse
    @checkin = params[:checkin_id]
    @primary_client_id = Checkin.find_by_client_checkin_id(@checkin).primary_client_id
  end

  def index
    # params are :city, :zip, :client_name, :street_name
    @household_search = HouseholdSearch.new(params[:household_search])
    @households = Household.matching(@household_search)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @household = Household.find(params[:id])
    @household.delete # note, clients are not deleted
    redirect_to households_path, :notice => 'Household deleted'
  end

end
