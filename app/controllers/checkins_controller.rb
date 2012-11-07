class CheckinsController < ApplicationController
  # so that we can navigate away, fix an issue and navigate back with page refresh to reflect the fixed issue
  before_filter :set_cache_buster, :only => [ :create, :edit ]

  def new
    render :template => 'checkins/client_finder'
  end

  def create
    @client = Client.find(params[:client_id]) if params[:client_id]
    if @client.household
      checkin = Checkin.create(@client)
      redirect_to edit_client_checkin_path(@client,checkin.id)
    else
      render 'checkins/quickcheck_fail'
    end
  end

  def edit
    @client = Client.includes(:id_qualdoc, :household => [{:clients => :id_qualdoc}, :res_qualdoc, :gov_qualdoc, :inc_qualdoc]).find(params[:client_id]) if params[:client_id]
    @household = @client.household
    @household_qualification_docs = @client.household_qualification_docs(params[:id]).to_json unless !@household

    render :template => template,
      :layout => !request.xhr?,
      :locals => {:client => @client,
                  :household => @household,
                  :household_qualification_docs => @household_qualification_docs,
                  :household_color_code => @household && @household.distribution_color_code,
                  :primary_checkin_id => params[:id]}
  end

  # at the conclusion of the quickcheck procedure:
  def update
    client_id = params[:client_id]
    client_checkin_id = params[:id]
    docs = params[:qualification_documents].values
    do_updates(docs, client_checkin_id)
    render :nothing => true, :status => :ok # the "quickcheck complete" scenario
  end

  def update_and_show_client
    client_id = params[:client_id]
    docs = params[:qualification_documents]
    client_checkin_id = params[:checkin_id]
    do_updates(docs, client_checkin_id)
    redirect_to checkin_client_path(client_checkin_id, client_id)
  end

  def update_and_show_household
    household_id = params[:household_id]
    docs = params[:qualification_documents]
    client_checkin_id = params[:checkin_id]
    do_updates(docs, client_checkin_id)
    redirect_to checkin_household_path(client_checkin_id, household_id)
  end

  private

  def do_updates(docs, client_checkin_id)
    QualificationDocument.update_collection(docs)
    checkin = Checkin.find_by_client_checkin_id(client_checkin_id)
    checkin.update(docs)
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def template
    if !@household
      'checkins/quickcheck_fail'
    elsif @client.household_with_errors
      'checkins/quickcheck_with_errors'
    else
      'checkins/quickcheck_without_errors'
    end
  end
end
