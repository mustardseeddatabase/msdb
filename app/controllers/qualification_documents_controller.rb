class QualificationDocumentsController < ApplicationController
  helper :checkin, :clients, :households # SHOULD NOT BE NECESSARY! but required for testing (not dev) after upgrade to Rails 3.2.5
  # the index method with no parameters presents the page into which ajax
  # results may be inserted. The index method responding to an ajax
  # request requires a client id.
  # Qualification documents are presented relating to a particular client and household.
  # A dedicated controller is used rather than overload the REST methods of the 
  # client or household controllers.
  def index
    if params[:client_id]
      @client = Client.includes(:id_qualdoc, :household => [{:clients => :id_qualdoc}, :res_qualdoc, :gov_qualdoc, :inc_qualdoc]).find(params[:client_id])
      # when there are no errors, the checkin will not be created during update, so create it now, with no warnings
      @client.checkins.create unless @client.household_with_errors
      @household = @client.household
      @household_client_docs = @household.client_docs.to_json
      @household_docs = @household.qualification.to_json
    end

    respond_to do |format|
      format.js
      format.html # without @client it's a blank page, 
                  # with @client it shows qualification document errors 
                  # or the 'no errors' page with color code
    end
  end

  def update
    @client    = Client.find(params[:client_id])       if params[:client_id]

    checkin = @client.checkins.build # for the head of household, takes the warnings for household qualdocs (inc, res, gov)

    params[:qualification_documents].each do |qualdoc_id,val|
      upload = (val.keys.include? 'docfile')
      val.merge!(:date => Date.today, :warnings => 0) if upload
      qd = QualificationDocument.find(qualdoc_id)
      qd.assign_attributes(val, :without_protection => true)
      warn = qd.changed_attributes.keys.include?("warnings")
      if qd.belongs_to?(@client)
        checkin[qd.document_type + "_warn"] = warn
      else
        checkin.proxy_checkins.build(:client => qd.client, (qd.document_type + "_warn") => warn)
      end
      if qd.save && upload
        flash[:info] = "Document saved"
      end
    end

    checkin.save if checkin

    respond_to do |format|
      format.js # the "quickcheck complete" scenario
      format.html do # after a document has been uploaded
        redirect_to qualification_documents_url(:client_id => params[:client_id]) # documents are being uploaded during quickcheck
      end
    end
  end

  def show
    qualdoc = QualificationDocument.find(params[:id])
    send_file(qualdoc.docfile.current_path)
  end
end
