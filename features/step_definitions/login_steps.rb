Given /^a user account with username "([^"]*)" and password "([^"]*)"$/ do |username, password|
  @user = User.create(:login => username,
              :email => 'norm@acme.com',
              :firstName => 'Norman',
              :lastName => 'Normal')
  @user.update_attribute(:enabled , true)
  @user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:activated_at, DateTime.new(2011,1,1))
  crypted_password = User.encrypt(password, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:crypted_password, crypted_password)
end

Given /^the user has "([^"]*)" role$/ do |role|
  @role = Role.find_or_create_by_name(:name => role)
  @user.user_roles.create(:role_id => @role.id)
end


Given /^no user is logged in$/ do
  # do nothing!
end

Given /^I am logged in with "([^"]*)" role$/ do |role|
  steps %Q{ Given a user account with username "someuser" and password "secret"
            And the user has "#{role}" role
            And permission is granted for "#{role}" to go to the "home#index" page
            When I go to the root page
            Then I fill in "login" with "someuser"
            And I fill in "password" with "secret"
            And I press "Log in..." }
end

Given /^I am logged in and on the "([^"]*)" page$/ do |page|
  steps %Q{ Given I am logged in with "admin" role
            And permission is granted for "admin" to go to the "#{page}" page
            And I am on the #{page} page }
end

Then /^There should be "([^"]*)" "([^"]*)"$/ do |number, object|
  object.singularize.capitalize.constantize.send('all').size.should == number.to_i
end

Given /^pending/ do
  pending # always
end

Given /^an arbitrary user account$/ do
  @user = User.create(:login => Faker::Name::first_name,
              :email => Faker::Internet::email,
              :firstName => Faker::Name::first_name,
              :lastName => Faker::Name::last_name)
  @user.update_attribute(:enabled , true)
  @user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:activated_at, DateTime.new(2011,1,1))
  crypted_password = User.encrypt(Faker::Name::first_name, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:crypted_password, crypted_password)
end

Given /^a role named "([^"]*)" is in the database$/ do |role|
  Role.create(:name => role)
end

Given /^an arbitrary user account with email "([^"]*)"$/ do |email|
  @user = User.create(:login => Faker::Name::first_name,
              :email => email,
              :firstName => Faker::Name::first_name,
              :lastName => Faker::Name::last_name)
  @user.update_attribute(:enabled , true)
  @user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:activated_at, DateTime.new(2011,1,1))
  crypted_password = User.encrypt(Faker::Name::first_name, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:crypted_password, crypted_password)
end

When /^I follow "([^"]*)" test$/ do |link_name|
  within(:xpath, "//tr[contains(./td/text(),'Norman')]") do
    click_link(link_name)
  end
end

Given /^I am a user whose account is disabled$/ do
  @user = User.create(:login => 'username',
              :email => 'norm@acme.com',
              :firstName => 'Norman',
              :lastName => 'Normal')
  @user.update_attribute(:enabled , false)
  @user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:activated_at, DateTime.new(2011,1,1))
  crypted_password = User.encrypt('secret', '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:crypted_password, crypted_password)
end

When /^I login$/ do
  steps %Q{ When I go to the root page
            Then I fill in "login" with "username"
            And I fill in "password" with "secret"
            And I press "Log in..."
  }
end

Then /^I should (not )*see an icon representing "([^"]*)"$/ do |yes_or_no, icon_name|
  if yes_or_no == "not "
    present = page.has_xpath?(".//div[@id='nav']/a[@id = '#{icon_name}']")
    present_but_disabled = present && (page.find(:xpath, ".//div[@id='nav']/a[@id = '#{icon_name}']")[:class].include?('disabled'))
    (present_but_disabled || !present).should == true
  else
    element_class = page.find(:xpath, ".//a[@id = '#{icon_name}']")[:class]
    enabled       = element_class.include?('enabled')
    button        = element_class.include?('nav_button')
    (enabled && button).should == true
  end
end

When /^I click on the icon representing "([^"]*)"$/ do |icon_name|
  find(:xpath, ".//a[@id = '#{icon_name}']").click
end

