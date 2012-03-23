Given /^There is one donation in the database$/ do
  Factory.create(:donation_with_known_barcode)
end

Given /^The donor is "([^"]*)"$/ do |donor_org|
  Donor.first.update_attribute(:organization, donor_org)
end

Given /^The date is "([^"]*)"$/ do |date|
  Donation.first.update_attribute(:created_at, DateTime.parse(date))
end

Then /^I should see (\d+) donated items$/ do |count|
  all(:css, '.transaction_item').size.should == count.to_i
end

Then /^I follow "([^"]*)" for the first donated item$/ do |link|
  within(".transaction_item"){ click_link link }
end

Then /^I should see an edit form$/ do
  # there should be 4 inputs in the form
  page.find(:css, ".transaction_item").all(:css,"input").size.should == 4
end

Then /^There should be an item with description "([^"]*)" in the database$/ do |description|
  Item.find_all_by_description(description).size.should == 1
end

Then /^I fill in item description with "([^"]*)"$/ do |text|
  fill_in('description', :with => text)
end

Then /^Donated items should have no editable fields$/ do
  all(:xpath, "//tr[@class = 'transaction_item']").each do |row|
    row.all(:xpath, ".//input[@type = 'text']").size.should == 0
  end
end

