When /^I upload a file$/ do
  @upload_filename = 'arbogast_id.pdf'
  attach_file( "docfile_input", File.join(::Rails.root.to_s, 'features', 'support', 'uploadable_files', @upload_filename))
  click_button "Upload file"
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

Then /^I should see a file selector$/ do
  page.should have_selector(:xpath, ".//input[@type='file']", :visible => true)
end

Then /^The uploaded file should be present in the uploaded file storage location$/ do
  `ls features/support/uploaded_files/`.should match(/#{@upload_filename}/)
end

Then /^I should not see a file selector$/ do
  not_in_the_dom = !page.has_selector?(:xpath, ".//input[@type='file']")
  not_visible = page.has_selector?(:xpath, ".//input[@type='file']", :visible => false)
  not_in_the_dom || not_visible
end

Then /^Fanny Arbogast should have (\d+) id warning$/ do |count|
  client = Client.find_by_lastName('Arbogast')
  client.id_warnings.should == count.to_i
end

Then /^I should see a view document link for "(.*?)"$/ do |first_last_name|
  last_first_name = first_last_name.split(" ").reverse.join(", ")
  find(:xpath,".//table/*/tr[contains(.,'#{last_first_name}')]").find(:xpath, "//div[@class = 'document_exists']")
end

Then /^I should see a delete document link for "(.*?)"$/ do |first_last_name|
  last_first_name = first_last_name.split(" ").reverse.join(", ")
  find(:xpath,".//table/*/tr[contains(.,'#{last_first_name}')]").find(:xpath, "//div[@class = 'delete_document_exists']")
end

Given /^I click "(.*?)" for "(.*?)"$/ do |link_name, first_last_name|
  in_the_row_for(first_last_name).find(:xpath, "//a[contains(.,'#{link_name}')]").click
end

def in_the_row_for(first_last_name)
  last_first_name = first_last_name.split(" ").reverse.join(", ")
  find(:xpath, ".//table/*/tr[contains(.,'#{last_first_name}')]")
end

Then /^The status for "(.*?)" should be "(.*?)"$/ do |first_last_name, status|
  debugger #this test is passing and it shouldn't!
  in_the_row_for(first_last_name).find(:xpath, ".//td[3]").text().should == status
end

