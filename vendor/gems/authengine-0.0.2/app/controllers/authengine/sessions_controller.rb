# This controller handles the login/logout function of the site.
require "date"

class Authengine::SessionsController < ApplicationController
  layout 'authengine/layouts/authengine'

  skip_before_filter :check_permissions, :only => [:new, :create, :destroy]


  def new
  end

  # user logs in
  def create
    logger.info "session controller: create"
    authenticate_with_password(params[:login], params[:password])
  end

  # user logs out
  def destroy
    self.current_user.forget_me if logged_in?
    remove_session_user_roles
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end

protected

  def remove_session_user_roles
    session[:role] = SessionRole.new
  end

  def authenticate_with_password(login, password)
    user = User.authenticate(login, password)
    if user == nil
      failed_login("Your username or password is incorrect.")
    elsif user.activated_at.blank?
      failed_login("Your account is not active, please check your email for the activation code.")
    elsif user.enabled == false
      failed_login("Your account has been disabled, please contact administrator.")
    else
      self.current_user = user
      session[:role] = SessionRole.new
      session[:role].add_roles(user.role_ids)
      successful_login
    end
  end

private

  def failed_login(message)
    logger.info "login failed with message: #{message}"
    flash[:error] = message
    render :action => 'new'
  end

  def successful_login
    # 'remember me' is not used in this application
    #if params[:remember_me] == "1"
      #self.current_user.remember_me
      #cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    #end
#   user is already logged-in
    flash[:notice] = "Logged in successfully"
    return_to = session[:return_to]
    if return_to.nil?
      redirect_to home_path
    else
      redirect_to return_to
    end
  end

end
