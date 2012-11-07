Then /^I should see an edit form for the item$/ do
  page.should have_css('#edit_item')
end

Then /^The item in the database with upc (\d+) should have description "([^"]*)"/ do |barcode, description|
  sleep(0.3)
  Item.find_by_upc(barcode).description.should == description
end

Then /^I should see "([^"]*)" for the item "([^"]*)"$/ do |arg1, arg2|
  page.find("#item_status").should have_link("Edit")
end

Then /^The "([^"]*)" item in the database should have "([^"]*)" "([^"]*)"$/ do |description, attribute, value|
  Item.find_by_description(description).send(attribute).should == value.to_i
end
