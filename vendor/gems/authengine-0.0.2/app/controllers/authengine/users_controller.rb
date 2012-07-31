# Besides the ususal REST actions, this controller contains show_self,
# edit_self and update_self actions.
# This permits access to be explicitly controlled via the
# check_permissions filter, distinguishing between actions on one's own
# model vs. actions on other users' models.
class Authengine::UsersController < ApplicationController
  layout 'authengine/layouts/authengine'
  #before_filter :not_logged_in_required, :only => [:new, :create]
  #before_filter :login_required, :only => [:show, :edit, :update]
  #before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  #before_filter :user_or_current_user, :only => [:show, :edit, :update]

  # activate is where a user with the correct activation code
  # is redirected to, so they can enter passwords and login name
  skip_before_filter :check_permissions, :only=>[:activate, :signup]

  def index
    @users = User.find(:all, :order=>"lastName, firstName")
  end

  def show
    @user = User.find(params[:id])
  end

  def show_self
    @user = current_user
    render :template=>"users/show"
  end

  def new
    @user = User.new
    @user.user_roles.build
    @roles = Role.all
  end

# users may only be created by the administrator from the index page
  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save!
    redirect_to authengine_users_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating the user account."
    @roles=Role.all
    render :action => 'new'
  end

  def edit # edit a user profile with id given
    @user = User.find(params[:id])
  end

  def edit_self # edit profile of current user
    @user = current_user
    render :template => 'users/edit'
  end

# account was created by admin and now user is entering username/password
  def activate
    # TODO must remember to reset the session[:activation_code]
    # looks as if setting current user (next line) was causing the user to be
    # logged-in after activation
    user = User.find_and_activate!(params[:activation_code])
    if user.update_attributes(params[:user].slice(:login, :email, :password, :password_confirmation))
      redirect_to root_path
    else
      flash[:warn] = user.errors.full_messages
      redirect_to signup_authengine_user_path(user)
    end
  rescue User::ArgumentError
    flash[:notice] = 'Activation code not found. Please ask the database administrator to create an account for you.'
    redirect_to new_authengine_user_path
  rescue User::ActivationCodeNotFound
    flash[:notice] = 'Activation code not found. Please ask the database administrator to create an account for you.'
    redirect_to new_authengine_user_path
  rescue User::AlreadyActivated
    flash[:notice] = 'Your account has already been activated. You can log in below.'
    redirect_to login_path
  end

  def update_self
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your profile has been updated"
      redirect_to authengine_users_path
    else
      flash[:notice] = @user.errors.full_messages
      render :action => 'edit'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to authengine_users_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to authengine_users_path
  end

  def disable
    @user = User.find(params[:id])
    unless @user.update_attribute(:enabled, false)
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to authengine_users_path
  end

  def enable
    @user = User.find(params[:id])
    unless @user.update_attribute(:enabled, true)
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to authengine_users_path
  end

  def signup
    @user = User.find(params[:id])
  end

protected

  def user_or_current_user
    if current_user.has_role?('administrator')
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

end
