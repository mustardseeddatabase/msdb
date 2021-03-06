module ApplicationHelper
  def submit_or_return_to(return_path, text = 'Save')
    haml_tag :table, {:style => 'padding-top:30px'} do
      haml_tag :tr do
        haml_tag :td, {:width => '180px'} do
          haml_tag :input, {:type => 'submit', :value => text, :style => "margin-right: 100px"}
        end
        haml_tag :td do
          haml_tag :a, "Cancel", {:href => return_path}
        end
      end
    end
  end

  def focus(input)
    haml_tag :script, "$(function(){$('##{input}').focus()})"
  end

  def race_options
    Client::Races.invert.sort.to_a
  end

  def nav_enable(path)
    current_role_permits?(path) ? 'enabled' : 'disabled'
  end

  def current_user_permitted?(path)
    controller = Controller.find_by_controller_name(path[:controller])
    action = Action.find_by_action_name_and_controller_id(path[:action],controller.id) unless controller.nil?
    user_roles = current_user.user_roles
    role_ids = user_roles.map(&:role_id)
    role_ids.any?{|rid| action && ActionRole.exists?(:action_id => action.id, :role_id => rid )}
  end

  def current_role_permits?(path)
    controller = Controller.find_by_controller_name(path[:controller])
    action = Action.find_by_action_name_and_controller_id(path[:action],controller.id) unless controller.nil?
    role_ids = session[:role].current_role_ids
    role_ids.any?{|rid| action && ActionRole.exists?(:action_id => action.id, :role_id => rid )}
  end
end
