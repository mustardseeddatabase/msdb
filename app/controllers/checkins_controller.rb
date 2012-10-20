class CheckinsController < ApplicationController
  # so that we can navigate away, fix an issue and navigate back with page refresh to reflect the fixed issue
  before_filter :set_cache_buster, :only => :new
  # the new method with no client id presents the client_finder
  # The new method responding to an ajax request requires a client id.
  # Qualification documents are presented relating to a particular client and household.
  def new
    @client = Client.includes(:id_qualdoc, :household => [{:clients => :id_qualdoc}, :res_qualdoc, :gov_qualdoc, :inc_qualdoc]).find(params[:client_id]) if params[:client_id]
    if @client
      # when there are no errors, the checkin will not be created during update, so create it now, with no warnings
      HouseholdCheckin.create_for(@client) if @client.has_no_checkin_errors
      @household = @client.household
      @household_qualification_docs = @client.household_qualification_docs.to_json unless !@household
    end

    render :template => template,
           :layout => !request.xhr?,
           :locals => {:client => @client,
                       :household => @household,
                       :household_qualification_docs => @household_qualification_docs,
                       :household_color_code => @household && @household.distribution_color_code}
  end

  # at the conclusion of the quickcheck procedure:
  def update
    client = Client.find(params[:client_id])
    docs = params[:qualification_documents].values

    QualificationDocument.update_collection(docs)
    HouseholdCheckin.update_for(client,docs)

    respond_to do |format|
      format.js { render :nothing => true, :status => :ok } # the "quickcheck complete" scenario
    end
  end

  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def template
    if !@client
      'checkins/client_finder'
    elsif !@household
      'checkins/quickcheck_fail'
    elsif @client.household_with_errors
      'checkins/quickcheck_with_errors'
    else
      'checkins/quickcheck_without_errors'
    end
  end
end
