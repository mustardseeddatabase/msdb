class CheckinsController < ApplicationController
  # so that we can navigate away, fix an issue and navigate back with page refresh to reflect the fixed issue
  before_filter :set_cache_buster, :only => :new
  # the new method with no parameters presents the page into which ajax
  # results may be inserted. The new method responding to an ajax
  # request requires a client id.
  # Qualification documents are presented relating to a particular client and household.
  def new
    if params[:client_id]
      @client = Client.includes(:id_qualdoc, :household => [{:clients => :id_qualdoc}, :res_qualdoc, :gov_qualdoc, :inc_qualdoc]).find(params[:client_id])
      # when there are no errors, the checkin will not be created during update, so create it now, with no warnings
      if @client.household && !@client.household_with_errors
        @client.household.household_checkins.create
        @client.household.clients.each do |client|
          client.client_checkins.create
        end
      end
      @household_qualification_docs = @client.household_qualification_docs.to_json
      @household = @client.household
    end

    if request.xhr?
      if !@household
         render :partial => 'quickcheck_fail', :locals => {:client => @client}
      elsif @client.household_with_errors
         render :partial => 'quickcheck_with_errors',
           :locals => {:client => @client,
                       :household => @household,
                       :household_qualification_docs => @household_qualification_docs,
                       :household_color_code => @household.distribution_color_code}

      else
        render :partial => 'quickcheck_without_errors', :locals => {:household_color_code => @household.distribution_color_code}
      end
     end
    end

    # at the conclusion of the quickcheck procedure:
    def update
      docs = params[:qualification_documents].values
      grouped_docs = docs.group_by{|doc| doc['id'] != "null" }
      docs_for_update = grouped_docs[true] || []
      new_docs = grouped_docs[false] || []
      grouped_by_association_docs = docs.group_by{|doc| doc['doctype'] == 'id' ? 'client' : 'household' }
      client_docs = grouped_by_association_docs['client']
      household_docs = grouped_by_association_docs['household']

      @client = Client.find(params[:client_id])
      @household = @client.household

      docs_for_update.each do |doc|
        qualdoc = QualificationDocument.find(doc['id'])
        qualdoc.update_attributes(doc.slice('date', 'warnings', 'confirm'))
      end

      new_docs.each do |doc|
        doctype = QualificationDocument::Types[doc['doctype']]
        qualdoc = doctype.constantize.send('create',doc.slice('date','warnings','association_id', 'confirm'))
      end

      household_checkin_attributes = household_docs.inject({}) do |hash, doc|
        hash[doc['doctype'] + '_warn'] = doc['warned']
        hash['household_id'] ||= doc['association_id']
        hash
      end

      household_checkin = HouseholdCheckin.create(household_checkin_attributes)

      client_docs.each do |doc|
        ClientCheckin.create(:client_id => doc['association_id'],
                             :id_warn => doc['warned'],
                             :household_checkin_id => household_checkin.id,
                             :primary => @client.id == doc['association_id'].to_i)
      end

      @color_code = @household.distribution_color_code

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
  end
