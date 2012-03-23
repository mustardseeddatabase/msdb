Then /^I should see an edit form for the item$/ do
  page.should have_css('#edit_item')
end

Then /^The item in the database with upc (\d+) should have description "([^"]*)"/ do |barcode, description|
  sleep(0.2)
  Item.find_by_upc(barcode).description.should == description
end
