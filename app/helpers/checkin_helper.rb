module CheckinHelper
  def qualification_error_message(object, param='id')
    document = object.send(param + '_qualdoc')
    description = document.class::Description
    qualification_identifier = object.is_a?(Client) ? object.first_last_name : "this household"
    date = document.expiry_date
    date ?
      "Date expired: #{description.capitalize} expired on #{date.to_formatted_s(:rfc822)} for #{qualification_identifier}" :
      "Date missing: There is no #{description} on file for #{qualification_identifier}"
  end

  def upload_link_text(param) # param is :id, :gov, :inc, or :res
    klass = (param.to_s + '_qualdoc').classify.constantize
    klass::Description.gsub(/ information/,'')
  end

  def warnings(checkin)
    if checkin.primary?
      text = checkin.totally_clean? ? "none" : ""
      unless checkin.clean?
        text += "Self: "
        warnings = []
        warnings << (checkin.id_warn? ? "Id" : "")
        warnings << (checkin.res_warn? ? "Residency" : "")
        warnings << (checkin.inc_warn? ? "Income" : "")
        warnings << (checkin.gov_warn? ? "Govt. Income" : "")
        text += warnings.join(", ")
      end

      unless checkin.proxies_clean?
        checkin.proxy_checkins.each do |ci|
          proxy_text = "Id: #{ci.client.first_last_name}" unless ci.clean?
          text = [text, proxy_text].join("<br/>")
        end
      end

      text.html_safe
    else
      checkin.clean? ? "none" : "Id"
    end
  end
end
