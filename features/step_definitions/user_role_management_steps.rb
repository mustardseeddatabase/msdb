Given /^a user account for user "([^"]*)" with role "([^"]*)"/ do |full_name, role|
  first_name, last_name = full_name.split(' ')
  @user = User.create(:login => Faker::Name::first_name,
              :email => Faker::Internet::email,
              :firstName => first_name,
              :lastName => last_name)
  @user.update_attribute(:enabled , true)
  @user.update_attribute(:salt, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:activated_at, DateTime.new(2011,1,1))
  crypted_password = User.encrypt(Faker::Name::first_name, '1641b615ad281759adf85cd5fbf17fcb7a3f7e87')
  @user.update_attribute(:crypted_password, crypted_password)
  role = Role.find_or_create_by_name(role)
  @user.user_roles.create(:role_id => role.id)
end

When /^I follow "([^"]*)" for "([^"]*)"$/ do |link, full_name|
  first_name, last_name = full_name.split(' ')
  within(:xpath, "//tr[td = '#{last_name}']") do
    click_link(link)
  end
end

Then /^"([^"]*)" should have "([^"]*)" "([^"]*)"$/ do |full_name, number, objects|
  sleep(0.2) # because when using capbyara-webkit (iso selenium) it's so fast that it doesn't wait for the db to get updated
  first_name, last_name = full_name.split(" ")
  u = User.find_by_lastName(last_name)
  u.send(objects.pluralize).size.should == number.to_i
end

Then /^There should be "(\d+)" "([^"]*)" for "([^"]*)"$/ do |count, user_role_model, role_name|
  model = user_role_model.camelize.constantize
  role = Role.find_by_name(role_name)
  model.send('find_all_by_role_id',role.id).size.should == count.to_i
end

Then /^a user_role is in the database for admin$/ do
  role = Role.find_by_name('admin')
  user_role = UserRole.where('role_id = ?',role.id).first
  user = User.find(user_role.user_id)
  user.user_roles.create(:role_id => role.id)
end

Then /^"([^"]*)" should not have permission to visit "([^"]*)"$/ do |user_full_name, controller_action|
  controller, action = controller_action.split('#')
  firstName, lastName = user_full_name.split(' ')
  user = User.find_by_firstName_and_lastName(firstName, lastName)
  ActionRole.permits_access_for(controller, action, user).should be_false
end

Then /^Current session role should be "([^"]*)"$/ do |role|
  session[:role].should == role
end
