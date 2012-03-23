module ClientsHelper
  def information_status(object,param)
    o = object.send((param.to_s + '_qualdoc').to_sym)
    haml_concat o.information_status
  end

  def client_document_link(client)
    if client.docfile_exists?
     link_to("View ID document", qualification_document_path(client.id_qualdoc))
    end
  end
end
