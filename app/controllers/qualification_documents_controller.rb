class QualificationDocumentsController < ApplicationController
  # so that we can navigate away, fix an issue and navigate back with page refresh to reflect the fixed issue
  before_filter :set_cache_buster, :only => :index
  # the index method with no parameters presents the page into which ajax
  # results may be inserted. The index method responding to an ajax
  # request requires a client id.
  # Qualification documents are presented relating to a particular client and household.
  def index
    if params[:client_id]
      @client = Client.includes(:id_qualdoc, :household => [{:clients => :id_qualdoc}, :res_qualdoc, :gov_qualdoc, :inc_qualdoc]).find(params[:client_id])
      # when there are no errors, the checkin will not be created during update, so create it now, with no warnings
      unless @client.household_with_errors
        @client.household.household_checkins.create
        @client.household.clients.each do |client|
          client.client_checkins.create
        end
      end
      @household_qualification_docs = @client.household_qualification_docs.to_json
      @household = @client.household
    end

    respond_to do |format|
      format.js
      format.html # without @client it's a blank page, 
                  # with @client but no household, it directs the user to create a household
                  # with @client it shows qualification document errors 
                  # or the 'no errors' page with color code
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
      qualdoc.update_attributes(doc.slice('date', 'warnings'))
    end

    new_docs.each do |doc|
      doctype = QualificationDocument::Types[doc['doctype']]
      qualdoc = doctype.constantize.send('create',doc.slice('date','warnings','association_id'))
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



    #params[:qualification_documents].each do |qualdoc_id,val|
      #upload = (val.keys.include? 'docfile')
      #val.merge!(:date => Date.today, :warnings => 0) if upload
      #qd = QualificationDocument.find(qualdoc_id)
      #qd.assign_attributes(val, :without_protection => true)
      #if qd.save && upload
        #flash[:info] = "Document saved"
      #end
    #end

    @color_code = @household.distribution_color_code

    respond_to do |format|
      format.js { render :nothing => true, :status => :ok } # the "quickcheck complete" scenario
    end
  end

  def upload
    qualification_document = QualificationDocument.find(params[:qualification_document_id])
    qualification_document.update_attributes({:date => Date.today, :warnings => 0, :docfile => params[:qualification_document][0]['docfile']})
    # TODO code smell here. The client_id_qualdocs should be split into client objects and qualdoc objects in the backbone models
    # it should only be necessary to respond with document information, not client attrs as they're unaffected by upload
    if qualification_document.type == "IdQualdoc"
      qualdoc = qualification_document.client.id_qualification_vector
    else
      qualdoc = qualification_document.qualification_vector
    end

    wrapped_response = "<textarea data-type='application/json'>#{qualdoc.to_json}</textarea>"
    render :text => wrapped_response, :status => 'ok'
  end

  def show
    qualdoc = QualificationDocument.find(params[:id])
    send_file(qualdoc.docfile.current_path)
  end

private
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
