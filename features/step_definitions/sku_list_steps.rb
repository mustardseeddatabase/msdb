Given /^The "([^"]*)" item has limit category "([^"]*)"$/ do |description, limit_category|
  limit_category = LimitCategory.create(:name => limit_category)
  category = Category.create(:name => 'Food', :limit_category_id => limit_category.id)
  Item.find_by_description(description).update_attribute(:category_id, category.id)
end

Given /^The "([^"]*)" item is identified as (not )?canonical$/ do |description, yes_or_no|
  canonical = yes_or_no.nil? ? 1 : 0
  Item.find_by_description(description).update_attribute(:canonical, canonical)
end

Then /^I should see "([^"]*)" for the item described as "([^"]*)"$/ do |link_text, item_description|
  page.find(:xpath, "//tr[@class = 'edit_item'][contains(.,'#{item_description}')]").should have_link(link_text)
end

Then /^I should see a link called "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

When /^I follow "([^"]*)" for the item described as "([^"]*)"$/ do |link_text, item_description|
  page.find(:xpath, "//tr[@class = 'edit_item'][contains(.,'#{item_description}')]").click_link(link_text)
end

Then /^The item description in the database should be "([^"]*)"$/ do |description|
  Item.find_by_description(description).should be_true
end

Then /^The "([^"]*)" item in the database should (not )?be designated as canonical$/ do |description,yes_or_no|
  sleep(0.2)
  if yes_or_no == "not "
    Item.find_by_description(description).canonical.should be_false
  else
    Item.find_by_description(description).canonical.should be_true
  end
end

Then /^I should not see any items in the preferred sku list$/ do
  sleep(0.2) # as it has a fade out effect
  page.all('.edit_item', :visible => true).size.should be_zero
end

Then /^I should see an item in the list with description "([^"]*)"$/ do |description|
  page.find(:xpath,"//tr[@class='edit_item'][contains(.,'#{description}')]").should be_true
end

Then /^The "([^"]*)" button should be (dis|en)abled$/ do |button_text, enable_disable|
  if enable_disable == 'en'
    page.find('#add_to_list')[:disabled].should == 'false'
  else
    page.find('#add_to_list')[:disabled].should == 'true'
  end
end
