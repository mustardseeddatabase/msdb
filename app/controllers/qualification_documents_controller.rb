class QualificationDocumentsController < ApplicationController
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

  def delete
    
  end
end
