module HouseholdsHelper
  def hide_in_checkin
    if params['checkin_id']
      "display:none"
    else
      "display:block"
    end
  end

  def search_terms
    @household_search.search_terms.to_s
  end

  def other_concerns
    @household.otherConcerns.blank? ? "(none)" : @household.otherConcerns
  end

  def household_document_link(param,household)
    link_name = ("#{param.capitalize}Qualdoc".constantize)::Description.capitalize
    if household.send(param+'_doc_exists?')
      link_to(link_name, qualification_document_path(household.send(param+'_qualdoc')))
    else
      link_name
    end
  end

  def document_date(param,household)
    household && household.send(param + "_date") && household.send(param + "_date").to_formatted_s(:rfc822)
  end
end
