module CheckinHelper
  def warnings(checkin)
    household_checkin = checkin.household_checkin
    text = ""
    text += "none" if household_checkin.totally_clean?
    text += household_warnings(household_checkin) unless household_checkin.clean?
    text += "<br/>" if !household_checkin.clean? && !household_checkin.clean_clients?
    text += client_warnings(checkin) unless household_checkin.clean_clients?
    text.html_safe
  end

private
  def household_warnings(household_checkin)
    text = "Household: "
    warnings = []
    warnings << "Residency" if household_checkin.res_warn
    warnings << "Income" if household_checkin.inc_warn
    warnings << "Govt. Income" if household_checkin.gov_warn
    text += warnings.join(", ")
    text
  end

  def client_warnings(checkin)
    checkins = checkin.related_client_checkins
    warnings = []
    checkins.each do |checkin|
      warnings << "Id: #{checkin.client.last_first_name}" if checkin.id_warn
    end
    warnings.compact.join("<br/>")
  end
end
