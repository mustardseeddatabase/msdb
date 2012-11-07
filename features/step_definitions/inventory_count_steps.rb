Then /^The inventory items list length should be "([^"]*)"$/ do |count|
  page.evaluate_script("inventory_app.transaction.transaction_items.length").should == count.to_i
end

Then /^The backbone inventory model should contain a "([^"]*)" of "([^"]*)"$/ do |attribute,value|
  page.evaluate_script("inventory_app.transaction.transaction_items.first().get('item').get('#{attribute}')").should == value.to_i
end

Then /^The backbone "([^"]*)" model should contain a "([^"]*)" of "([^"]*)"$/ do |model,attribute,value|
  page.evaluate_script("#{model}.transaction.transaction_items.first().get('item').get('#{attribute}')").should == value.to_i
end

Then /^The backbone "([^"]*)" transaction model should contain a quantity of "([^"]*)"$/ do |model,value|
  page.evaluate_script("#{model}.transaction.transaction_items.first().get('quantity')").should == value.to_i
end

Then /^The backbone inventory transaction model should contain a quantity of "([^"]*)"$/ do |count|
  page.evaluate_script("inventory_app.transaction.transaction_items.first().get('quantity')").should == count.to_i
end

When /^I follow Remove... for the Canned Peas item$/ do
  # a little brittle but couldn't find a better way!
  page.find(:xpath, ".//tr[@class='transaction_item']").all(:xpath,"td/a").first.click
end

Then /^The item cache item with barcode "([^"]*)" should have "([^"]*)" for "([^"]*)"$/ do |barcode, attribute, name|
  category = Category.find_by_name(name)
  item_attribute = page.evaluate_script("inventory_app.transaction.transaction_items.item_cache.detect(function(item){return item.get('upc') == #{barcode}}).get('#{attribute}')")
  attr = attribute.split("_")[1] # so "category_name" becomes "name" etc.
  item_attribute.should == category.send(attr)
end

Then /^The item with barcode "([^"]*)" should (not )?be editable$/ do |barcode, yes_or_no|
  if yes_or_no == "not "
    page.find(:xpath, ".//tr[@class='transaction_item'][contains(.,'#{barcode}')]").should_not have_content "Edit"
  else
    page.find(:xpath, ".//tr[@class='transaction_item'][contains(.,'#{barcode}')]").should have_content "Edit"
  end
end

Then /^I follow "(.*?)" for the autocomplete item$/ do |arg1|
  page.find(:css,"table#found_in_db").find(:css,"tr#description_autocomplete").find_link("Remove").click
end
