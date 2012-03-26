Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database$/ do |last_name, first_name, age|
  FactoryGirl.create(:client, 
          :lastName => last_name, 
          :firstName => first_name, 
          :birthdate => age.to_i.years.ago)
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database belonging to the household$/ do |last_name, first_name, age|
  household = Household.first
  FactoryGirl.create(:client, 
          :lastName => last_name, 
          :firstName => first_name, 
          :birthdate => age.to_i.years.ago, 
          :household_id => household.id,
          :id_qualdoc => FactoryGirl.create(:id_qualdoc, :warnings => nil))
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database with no household$/ do |last_name, first_name, age|
  FactoryGirl.create(:client,
          :lastName => last_name, 
          :firstName => first_name, 
          :birthdate => age.to_i.years.ago, 
          :household_id => nil,
          :id_qualdoc => FactoryGirl.create(:id_qualdoc, :warnings => nil))
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database belonging to the household, without an ID document$/ do |last_name, first_name, age|
  household = Household.first
  FactoryGirl.create(:client, 
          :lastName => last_name, 
          :firstName => first_name, 
          :birthdate => age.to_i.years.ago, 
          :household_id => household.id,
          :id_qualdoc => nil)
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database belonging to the household, with an ID document, (not )?head of household$/ do |last_name, first_name, age, yes_or_no|
  household = Household.first
  hoh = yes_or_no == 'not ' ? false : true
  FactoryGirl.create(:client, 
          :lastName => last_name, 
          :firstName => first_name, 
          :birthdate => age.to_i.years.ago, 
          :headOfHousehold => hoh,
          :household_id => household.id,
          :id_qualdoc => FactoryGirl.create(:id_qualdoc, :warnings => nil))
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)", with id date "([^"]*)" in the database belonging to the household$/ do |last_name, first_name, age, date|
  household = Household.first
  FactoryGirl.create(:client,
          :lastName => last_name,
          :firstName => first_name,
          :birthdate => age.to_i.years.ago,
          :household_id => household.id,
          :id_qualdoc => FactoryGirl.create(:id_qualdoc, :date => eval(date), :warnings => nil, :vi => 1))
end

Given /^"([^"]*)" is (not )?head of household$/ do |full_name, yes_or_no|
  first_name, last_name = full_name.split(' ')
  head = yes_or_no == "not " ? false : true
  client = Client.find_by_firstName_and_lastName(first_name, last_name)
  client.update_attribute(:headOfHousehold, head)
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)", with id date "([^"]*)", and (\d+) warning, in the database belonging to the household$/ do |last_name, first_name, age, date, warning_count|
  household = Household.first
  FactoryGirl.create(:client,
          :lastName => last_name,
          :firstName => first_name,
          :birthdate => age.to_i.years.ago,
          :household_id => household.id,
          :id_qualdoc => FactoryGirl.create(:id_qualdoc, :date => eval(date), :warnings => warning_count, :vi => 1))
end

Given /^there is a client with last name "([^"]*)", first name "([^"]*)", age "([^"]*)" in the database belonging to the household, with an ID document$/ do |last_name, first_name, age|
  household = Household.first
  id_qualdoc = FactoryGirl.create(:id_qualdoc,
                       :date => 1.month.ago,
                       :warnings => 0,
                       :vi => 1,
                       :docfile => File.new(File.join(Rails.root,'features', 'support', 'upload_files','arbogast_id.pdf')))
  FactoryGirl.create(:client, :lastName => last_name,
          :firstName => first_name,
          :birthdate => age.to_i.years.ago,
          :household_id => household.id,
          :id_qualdoc => id_qualdoc)
end

Then /^I click "([^"]*)"$/ do |active_text|
  find(:xpath, ".//li[text()=\"#{active_text}\"]").click
end

Given /^there is a household with residency expired, income expiring and govtincome valid in the database$/ do
  h = FactoryGirl.create(:household_with_docs)
  h.res_qualdoc.update_attribute(:date, 7.months.ago)
  h.inc_qualdoc.update_attribute(:date, 6.months.ago.advance(:weeks => 1))
  h.gov_qualdoc.update_attribute(:date, 1.month.ago)
  h.perm_address.update_attributes(:address => '121 Apple Lane', :city => 'Pendleton', :zip => '10101')
end

Given /^there is a household with residency, income and govtincome expired in the database$/ do
  perm_address = FactoryGirl.create(:perm_address, :address => '121 Apple Lane', :city => 'Pendleton', :zip => '10101')
  FactoryGirl.create(:household_with_expired_docs,
                 :perm_address_id => perm_address.id)
end

Given /^there is a household with residency, income and govtincome current in the database$/ do
  perm_address = FactoryGirl.create(:perm_address, :address => '121 Apple Lane', :city => 'Pendleton', :zip => '10101')
  FactoryGirl.create(:household_with_current_docs,
                 :perm_address_id => perm_address.id)
end


Then /^I should see that the residency information has expired$/ do
  find(:xpath,".//table/*/tr[contains(.,'Residency verification information') and contains(.,'expired on')]")
end

Then /^I should see that the income information is expiring$/ do
  find(:xpath,".//table/*/tr[contains(.,'Income verification information') and contains(.,'expires on')]")
end

Then /^I should see that the govt income information is valid$/ do
  find(:xpath,".//table/*/tr[contains(.,'Government income verification information') and contains(.,'current')]")
end

Given /^I am quickchecking Fanny Arbogast/ do
  steps %Q{ Given I am on the client quickcheck page
            And I fill in "lastName" with "gas"
            Then I should see "Arbogast, Fanny. 20"
            When I click "Arbogast, Fanny. 20"
            Then I should see "Permanent address"}
end

Given /^I am quickchecking Norman Normal/ do
  steps %Q{ Given I am on the client quickcheck page
            And I fill in "lastName" with "norm"
            Then I should see "Normal, Norman. 20"
            When I click "Normal, Norman. 20"
            Then I should see "Permanent address"}
end

Given /^I am quickchecking a client without errors, Fanny Arbogast/ do
  steps %Q{ Given I am on the client quickcheck page
            And I fill in "lastName" with "gas"
            Then I should see "Arbogast, Fanny. 20"
            When I click "Arbogast, Fanny. 20" }
end

Then /^I should see "([^"]*)" warnings for "([^"]*)"$/ do |count, category|
  find(:xpath,".//table/*/tr[contains(.,'#{category}')]/td[4]").text.should == count
end

Then /^I should (not )?see a button called "([^"]*)"$/ do |yes_or_no, button_name|
  if yes_or_no == 'not '
    page.should have_xpath(".//input[@value = '#{button_name}'][@type = 'submit'][contains(@style,'display: none')]")
  else
    page.should have_xpath(".//input[@value = '#{button_name}'][@type = 'submit'][contains(@style,'display: block')]")
  end
end

Then /^I should see a file selector$/ do
  page.should have_selector(:xpath, ".//input[@type='file']", :visible => true)
end

Then /^I should not see a file selector$/ do
  not_in_the_dom = page.has_no_selector?(:xpath, ".//input[@type='file']")
  not_visible = page.has_selector?(:xpath, ".//input[@type='file']", :visible => false)
  not_in_the_dom || not_visible
end

Then /^Fanny Arbogast should have (\d+) id warning$/ do |count|
  client = Client.find_by_lastName('Arbogast')
  client.id_warnings.should == count.to_i
end

When /^I upload a file$/ do
  attach_file( "docfile_input", File.join(::Rails.root.to_s, 'features', 'support', 'upload_files', 'arbogast_id.pdf'))
  click_button "Upload file"
end

Then /^I should (not )?see a link to "([^"]*)"$/ do |yes_no, link_name|
  if yes_no == 'not '
    page.should have_no_link(link_name), "there was a link called '#{link_name}' when there shouldn't have been"
  else
    page.should have_link(link_name), "couldn't find a link called '#{link_name}'"
  end
end

When /^I click the browser back button$/ do
  #puts page.evaluate_script('window.history')
  page.evaluate_script('window.history.go(-1)')
end

Then /^I select (faker )?options for the following select boxes:$/ do |faker,table|
  table.hashes.each do |hash|
    if faker == "faker "
      page.select hash[:value], :from => hash[:field]
    else
      page.select eval(hash[:value]), :from => hash[:field]
    end
  end
end

Given /^The birthdate of Fanny Arbogast in the database is "([^"]*)"$/ do |arg1|
  Client.where(:firstName => "Fanny", :lastName => "Arbogast").first.update_attribute(:birthdate, Date.new(1991,7,28))
end

Then /^I should (not )?see "([^"]*)" for "([^"]*)"$/ do |yes_or_no, text, name|
  found_text = find('#residents').find(:xpath, ".//tr[contains(.,'#{name}')]").find(:xpath, './td[3]').text()
  if yes_or_no == "not "
    found_text.should be_blank
  else
    found_text.should == text
  end
end

Then /^"([^"]*)" should be head of household$/ do |name|
  firstName, lastName = name.split(' ')
  Client.find_by_firstName_and_lastName(firstName, lastName).headOfHousehold.should == true
end

Then /^The household should have exactly one head$/ do
  Household.first.clients.map(&:headOfHousehold?).count(true).should == 1
end

Then /^"([^"]*)" should not be in the database$/ do |name|
  firstName, lastName = name.split(' ')
  Client.find_by_firstName_and_lastName(firstName, lastName).should be_nil
end

Then /^"([^"]*)" should have (\d+) checkin$/ do |name, count|
  firstName, lastName = name.split(' ')
  client = Client.find_by_firstName_and_lastName(firstName, lastName)
  client.checkins.length.should == count.to_i
end

Then /^"([^"]*)" last checkin should have "([^"]*)" "([^"]*)"$/ do |name, field, true_or_false|
  firstName, lastName = name.split(' ')
  client = Client.find_by_firstName_and_lastName(firstName, lastName)
  expectation = true_or_false == "true" ? true : false
  client.checkins.last.send(field).should == expectation
end

Then /^there should be "([^"]*)" "([^"]*)" in the database$/ do |count, model|
  model.singularize.classify.constantize.send('count').should == count.to_i
end


