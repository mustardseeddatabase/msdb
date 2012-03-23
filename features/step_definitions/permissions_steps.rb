Given /^permission is granted for "([^"]*)" to go to the "([^"]*)" page$/ do |role, page|
  controller_name, action_name = page.split('#')
  @controller = Controller.find_or_create_by_controller_name(controller_name)
  @action = Action.find_or_create_by_action_name_and_controller_id(action_name, @controller.id)
  role = Role.find_by_name(role)
  role.actions << @action
  role.save
end

Given /^permissions are granted for "([^"]*)" to visit the following pages:$/ do |role, table|
  table.hashes.each do |hash|
    steps %Q{Given permission is granted for "#{role}" to go to the "#{hash[:page]}" page}
  end
end

