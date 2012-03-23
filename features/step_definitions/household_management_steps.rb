Then /^I check the following:$/ do |table|
  table.hashes.each do |hash|
    check (hash[:field])
  end
end

Then /^I select dates for the following fields:$/ do |table|
  table.hashes.each do |hash|
    #select_date( hash[:field], :with => hash[:value] ) # old format
    select_date( hash[:value], :from => hash[:field] )
  end
end

Then /^I select dynamic dates for the following fields:$/ do |table|
  table.hashes.each do |hash|
    #select_date( hash[:field], :with => eval(hash[:value]) ) # old format
    select_date( eval(hash[:value]), :from => hash[:field] )
  end
end

Given /^there is a household in the database$/ do
  perm_address = Factory.create(:perm_address, :address => '121 Apple Lane', :city => 'Pendleton', :zip => '10101')
  Factory.create(:household, :perm_address_id => perm_address.id)
end

Given /^there are households with zipcodes "([^"]*)" and "([^"]*)" in the database$/ do |zip1, zip2|
  perm_address1 = Factory.create(:perm_address, :zip => zip1)
  temp_address1 = Factory.create(:temp_address, :zip => '')
  perm_address2 = Factory.create(:perm_address, :zip => '')
  temp_address2 = Factory.create(:temp_address, :zip => zip2)
  hh1 = Factory.create(:household_with_docs)
  hh1.perm_address = perm_address1
  hh1.temp_address = temp_address1
  hh2 = Factory.create(:household_with_docs)
  hh2.perm_address = perm_address2
  hh2.temp_address = temp_address2
end

Given /^there are households with cities "([^"]*)" and "([^"]*)" in the database$/ do |city1, city2|
  h1 = Factory(:household_with_docs)
  h1.perm_address.update_attribute(:city, city1)
  h2 = Factory(:household_with_docs)
  h2.perm_address.update_attribute(:city, city2)
end

Given /^there is a household with "([^"]*)" "([^"]*)" in the database$/ do |attribute, value|
  Factory.create(:household, attribute.to_sym => value)
end

Given /^there are households with street names "([^"]*)" and "([^"]*)" in the database$/ do |street_name1, street_name2|
  perm_address1 = Factory.create(:perm_address, :address => street_name1)
  temp_address1 = Factory.create(:temp_address, :address => '')
  perm_address2 = Factory.create(:perm_address, :address => '')
  temp_address2 = Factory.create(:temp_address, :address => street_name2)
  Factory.create(:household, :perm_address => perm_address1, :temp_address => temp_address1)
  Factory.create(:household, :perm_address => perm_address2, :temp_address => temp_address2)
end

Given /^there are households with cities "([^"]*)" and "([^"]*)", with no temporary addresses, in the database$/ do |city1, city2|
  h1 = Factory(:household_with_docs)
  h1.perm_address.update_attribute(:city, city1)
  h1.update_attribute(:temp_address_id, nil)
  h2 = Factory(:household_with_docs)
  h2.perm_address.update_attribute(:city, city2)
  h2.update_attribute(:temp_address_id, nil)
end

Given /^there is a household with all three qualification documents in the database$/ do
  household = Factory.create(:household)
  res_qualdoc = Factory.create(:res_qualdoc,
                        :association_id => household.id,
                        :date => 1.month.ago,
                        :warnings => 0,
                        :vi => 1)
  inc_qualdoc = Factory.create(:inc_qualdoc,
                        :association_id => household.id,
                        :date => 1.month.ago,
                        :warnings => 0,
                        :vi => 1)
  gov_qualdoc = Factory.create(:gov_qualdoc,
                        :association_id => household.id,
                        :date => 1.month.ago,
                        :warnings => 0,
                        :vi => 1)
  Factory.create(:client, :household_id => household.id)
  household.clients {|clients| [clients.association(:client)]}
end

When /^I visit the households\#show page$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there are clients with last names "([^"]*)" and "([^"]*)" in the database$/ do |client_name1, client_name2|
  Factory.create(:client, :lastName => client_name1)
  Factory.create(:client, :lastName => client_name2)
end

When /^I select the autocomplete result "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^there is a household with client "([^"]*)" in the database$/ do |name|
  perm_address1 = Factory.create(:perm_address)
  temp_address1 = Factory.create(:temp_address)
  household = Factory.create(:household, :perm_address => perm_address1, :temp_address => temp_address1)
  Factory.create(:client, :lastName => name, :household_id => household.id)
  household.clients {|clients| [clients.association(:client)]}
end

When /^I follow "([^"]*)" for household "([^"]*)"$/ do |link, household|
  within(:xpath, "//tr[td = '#{household}']") do
    click_link(link)
  end
end

Then /^I should see no query results$/ do
  page.find(:xpath, ".//div[@id = 'households']").should_not have_xpath('./table')
end

Given /^I am logged in and on the "([^"]*)" page with query string "([^"]*)"$/ do |page, query|
  steps %Q{ Given I am logged in with "admin" role
            And permission is granted for "admin" to go to the "#{page}" page
            And I am on the #{page+"?"+query} page }
end

Given /^I visit the "([^"]*)" page with query string "([^"]*)"$/ do | page, query|
  step "I am on the #{page+"?"+query} page"
end

Then /^I click the back button$/ do
  page.evaluate_script('window.history.back()')
end

Then /^I click the forward button$/ do
  page.evaluate_script('window.history.forward()')
end

Then /^I should see (\d+) resident(s?) in the household$/ do |count, s|
  sleep 0.5 # not sure why, could be due to previous popup confirmation? but this is necessary for passing test!
  (page.all('#residents tr').size - 1).should == count.to_i # because there is one more row than the # residents
end

Then /^I confirm the removal$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I follow the link to remove "([^"]*)" as resident$/ do |name|
  within(:xpath, "//tr[contains(.,'#{name}')]") do
    click_link('Remove resident')
  end
end
