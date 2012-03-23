Given /^I have a user account that has not been activated$/ do
  @user = User.create(:login => Faker::Name::first_name,
              :email => Faker::Internet::email,
              :firstName => Faker::Name::first_name,
              :lastName => Faker::Name::last_name)
  @user.update_attribute(:activated_at, nil)
  @user.update_attribute(:activation_code, "123456789abcdef")
end

Given /^There is not a privacy policy file available$/ do
  policy = '_privacy_policy.html.haml'
  path = File.join(Rails.root, 'app', 'views', 'authengine', 'users')
  filename = File.join(path, policy)
  !File.exists?(filename)
end


Given /^There is a privacy policy file available$/ do
  policy = '_privacy_policy.html.haml'
  path = File.join(Rails.root, 'app', 'views', 'authengine', 'users')
  filename = File.join(path, policy)
  File.exists?(filename)
end

When /^I wait until "([^"]*)" is visible$/ do |selector|
  sleep(1)
  page.has_css?("#{selector}", :visible => true)
end

Then /^I check all (\d+) checkboxes$/ do |arg1|
  (1..9).each { |i| find("#privacy_policy").check("user_cb_cb#{i}") }
end

Then /^I don't check all checkboxes$/ do
  (1..7).each { |i| find("#privacy_policy").check("user_cb_cb#{i}") }
end

Given /^I have a user account that has been activated$/ do
  @user = User.create(:login => Faker::Name::first_name,
              :email => Faker::Internet::email,
              :firstName => Faker::Name::first_name,
              :lastName => Faker::Name::last_name)
  @user.update_attribute(:activated_at, Date.new(2009,1,1))
  @user.update_attribute(:activation_code, "123456789abcdef")
end

