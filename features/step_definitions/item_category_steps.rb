Then /^The limit category field should have selected value "([^"]*)"$/ do |text|
  value = LimitCategory.find_by_name(text).id
  page.all(:css,"#limit_category_id option")[value].should be_selected
end
