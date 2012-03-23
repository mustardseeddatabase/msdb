Given /^There is a role called "([^"]*)" in the database$/ do |role_name|
  Role.create(:name => role_name)
end

Given /^There is a role called "([^"]*)" in the database descendent of "([^"]*)"$/ do |role, parent|
  parent_role = Role.find_or_create_by_name(parent)
  role = Role.create(:name => role, :parent_id => parent_role.id)
end

When /^I follow "([^"]*)" for the role "([^"]*)"$/ do |link_name, role|
  within(:xpath,".//table/tbody/tr[contains(.,'i_do_everything')]/td[2]") do
   click_link("Remove")
  end
end

Then /^I should not see "([^"]*)" for "([^"]*)" role$/ do |linkname, rolename|
  find(:xpath,".//table/tr[contains(.,'#{rolename}')]").all(:xpath,'td')[1].text().should_not == linkname
end

Given /^There is a 'developer' role in the database$/ do
  Role.create(:name => 'developer')
end

Then /^"([^"]*)" role should have parent "([^"]*)"$/ do |role, parent|
  Role.find_by_name(role).parent.name.should == parent
end

