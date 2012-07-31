# AuthorizedSystem is 'include'd in ActionController by the authengine engine
# see lib/authengine/engine.rb
module AuthorizedSystem
  # established for the session when the user logs in
  # may be modified later if user's roles are modified
  # or if session is downgraded
  def current_role_ids=(ids)
    session[:role].current_role_ids = ids
  end

  def current_role_ids
    session[:role].current_role_ids
  end

  def action_permitted?(controller, action)
    ActionRole.permits_access_for(controller, action, current_role_ids)
  end

  def permitted?(controller, action)
    action_permitted?(controller, action) && logged_in?
  end

  # for each and every action, we check the configured permission
  # for the role(s) assigned to the logged-in user
  # The controller and action can be passed as parameters, to check whether or not to display a link/button
  # or else the current request controller/action are used to check whether or not to display a page
  def check_permissions(controller = request.parameters["controller"], action = request.parameters["action"])
    permission = false
    if !logged_in?
      logger.info "access denied: not logged in"
      access_denied
    elsif permitted?(controller, action)
      permission = true
    else
      logger.info "permission denied, #{controller}, #{action}"
      permission_denied
    end
    permission
  end

end
