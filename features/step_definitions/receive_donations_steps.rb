Given /^There is an item with a barcode "([^"]*)" and description "([^"]*)" in the database$/ do |barcode, description|
  FactoryGirl.create(:item, :upc => barcode, :description => description)
end

Given /^Item with barcode "([^"]*)" has no category configured$/ do |barcode|
  item = Item.find_by_upc(barcode.to_i)
  item.update_attribute(:category_id, nil)
end

When /^I scan an item with barcode "([^"]*)"$/ do |barcode|
  steps %Q{ When I fill in autocomplete "item_barcode" with "#{barcode}" 
            And I hit enter in the item_barcode field }
end

And /^I hit enter in the item_barcode field$/ do
  key_code = 13
  id = 'item_barcode'
  eventName = 'keyup'

  script =<<-EOS
    event = document.createEvent("KeyboardEvent");
    if (typeof(event.initKeyboardEvent) != 'undefined') {
        event.initKeyboardEvent("#{eventName}", true, false, window, false, false, false, false, #{key_code}, 0);
      } else {
        event.initKeyEvent("#{eventName}", true, false, window, false, false, false, false, #{key_code}, 0);
      }
    document.getElementById('#{id}').dispatchEvent(event)
  EOS
  page.execute_script(script)
end

Given /^This scenario is pending$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a text field with the value "([^"]*)" within: #found_in_db/ do |value|
  sleep(0.1)
  page.find(:xpath,"//table[@id='found_in_db']").all(:xpath, './tbody/tr/td/input').map{|e| e.value}.should include(value)
end

Given /^Item with barcode "([^"]*)" count is "([^"]*)"$/ do |barcode, count|
  Item.find_by_upc(barcode).update_attribute(:count, count)
end

Given /^Item with barcode "([^"]*)" weight is invalid$/ do |barcode|
  Item.find_by_upc(barcode).update_attribute(:weight_oz, nil)
end

Then /^I should see "([^"]*)" entr(?:y|ies) with the description "([^"]*)" and barcode "([^"]*)"$/ do |count, description, barcode|
  all(:xpath,"//table/tbody/tr[contains(.,'#{description}')][contains(.,'#{barcode}')]").length.should == count.to_i
end

Then /^The second entry has text entry field for quantity$/ do
  all(:xpath, "//tr[@class='transaction_item']")[0].all('td')[4].should have_css('#donated_item_quantity')
end

Then /^The first entry does not have an text entry field for quantity$/ do
  all(:xpath, "//tr[@class='transaction_item']")[1].all('td')[4].should_not have_css('#donated_item_quantity') # if existing item template
end

Then /^Quantity for "([^"]*)" should be "([^"]*)"$/ do |description, count|
  all(:xpath, "//table/tbody/tr/td/input").map(&:value).should include(count)
end

Given /^There is an item with description "([^"]*)" in the database$/ do |description|
  FactoryGirl.create(:item, :description => description)
end

Given /^There is a no-barcode item with description "([^"]*)" in the database$/ do |description|
  FactoryGirl.create(:item_with_sku, :description => description)
end


Given /^The "([^"]*)" item has a sku instead of a barcode$/ do |description|
  Item.find_by_description(description).update_attributes(:sku => 123, :upc => nil)
end

Then /^I should see a blank item row$/ do
  page.should have_css('tr#description_autocomplete')
end

Then /^The backbone model should contain a count of "([^"]*)"$/ do |count|
  page.evaluate_script("donation_app.transaction.transaction_items.first().get('item').get('count')").should == count.to_i
end

Then /^The backbone model should contain a quantity of "([^"]*)"$/ do |count|
  page.evaluate_script("donation_app.transaction.transaction_items.first().get('quantity')").should == count.to_i
end

Given /^The "([^"]*)" item has the following attributes:$/ do |description, table|
  item = Item.find_by_description(description)
  attrs = table.rows.inject({}){|hash,ar| hash.merge!({ar[0]=>ar[1]})}
  attrs.each do |attr,val|
    item.update_attribute(attr, val)
  end
end

Then /^I should see "([^"]*)" in the "([^"]*)" field$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I fill in the following fields:$/ do |table|
  table.rows.each do |row|
    field, value = row
    steps %Q{When I fill in "#{field}" with "#{value}"}
  end
end

Then /^"([^"]*)" field should (not )?have class "([^"]*)"$/ do |fieldname,yes_or_no,classname|
  field_class = all(:xpath, ".//table[@id='found_in_db']/tbody/tr")[1].find(:xpath,".//input[@id='#{fieldname}']")[:class]
  if yes_or_no.nil?
    field_class.should match(/#{classname}/)
  else
    field_class.should_not match(/#{classname}/)
  end
end

Then /^Count field should be text not form field$/ do
  page.should have_selector(:xpath, ".//table[@id='found_in_db']/tbody/tr/td[@id='count']")
end

Then /^First item should be a distribution item with only quantity as required input$/ do
  all(:xpath, ".//table[@id='found_in_db']/tbody/tr")[1].all(:xpath, ".//input[@type='text']").length.should == 1
end

Then /^I should see "([^"]*)" in the first distributed item$/ do |description|
  all(:xpath, ".//table[@id='found_in_db']/tbody/tr")[1].all(:xpath, "./td")[1].text().should == description
end

Then /^The donated items list length should be "([^"]*)"$/ do |count|
  page.evaluate_script("donation_app.transaction.transaction_items.length").should == count.to_i
end

Then /^I should see "([^"]*)" in the most recent entry$/ do |description|
  sleep(0.2)
  page.find(:css, "#found_in_db .transaction_item #description").text().should == description
end

Then /^The item with barcode "([^"]*)" in the database should have a description "([^"]*)"$/ do |barcode, description|
  Item.find_by_upc(barcode).description.should == description
end

Then /^only the first item should have an edit link$/ do
  page.find(:xpath, ".//tr[@class='transaction_item']").should have_content('Edit')
  page.all(:xpath, ".//tr[@class='transaction_item']").slice(1,99).each do |row|
    row.should_not have_content('Edit')
  end
end

Then /^All scanned items should have edit links$/ do
  scanned_item_count = page.all(:xpath, ".//tr[@class='transaction_item']").size
  edit_link_count = page.all(:xpath, ".//tr[@class='transaction_item']/td[contains(.,'Edit')]").size
  scanned_item_count.should == edit_link_count
end

Then /^Both scanned items should have edit links$/ do
  page.all(:xpath, ".//tr[@class='transaction_item']/td[contains(.,'Edit')]").size.should == 2
end

Then /^I should (not )?see a description autocomplete form$/ do |yes_or_no|
  if yes_or_no == 'not '
    page.should have_no_css('#description_autocomplete')
  else
    page.should have_css('#description_autocomplete')
  end
end

When /^There should be (\d+) transaction item$/ do |count|
  page.evaluate_script("donation_app.transaction.transaction_items.length").should == count.to_i
end

When /^I follow "([^"]*)" for (?:donation|inventory) item "([^"]*)"$/ do |link, description|
  el = page.find(:css, "#found_in_db").find(:xpath, "//tr[contains(.,'#{description}')]")
  within(el){click_link link}
end

