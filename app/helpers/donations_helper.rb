module DonationsHelper
  def donor_options
    blank_option = "<option value=\"0\">Select a donor...</option>"
    (blank_option + options_from_collection_for_select(@donors, :id, :organization)).html_safe
  end
end
