class Authengine::UserRolesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @all_roles = Role.all(:order => :name)
    @user_role = UserRole.new(:user_id => @user.id)
  end

  def create
    @user = User.find(params[:user_id])
    # session_user_roles are created by the process of downgrading the role
    # associated with the current session for the purpose of limiting access
    # when configuring a session for just one purpose (e.g.) checkout
    if params[:session_user_role]
      @user.session_user_roles.create(params[:session_user_role].delete_if{|k,v| k == "type" })
      role_name = Role.find(params[:session_user_role][:role_id]).name
      flash[:info] = "Current session now has #{role_name} role"
      redirect_to home_path
    else
      @user.user_roles.create(params[:user_role])
      redirect_to authengine_user_user_roles_path(@user)
    end
  end

  def destroy
    user_role = UserRole.find_by_role_id_and_user_id(params[:id],params[:user_id])
    user_role.destroy
    redirect_to authengine_user_user_roles_path(params[:user_id])
  end

  def new
    @user = User.find(params[:user_id])
    @user_role = UserRole.new(:user_id => @user.id)
    @roles = Role.lower_than(current_user.user_roles.map(&:role))
  end

  def edit
    @user = User.find(params[:user_id])
    @user_role = UserRole.new(:user_id => @user.id)
    @roles = Role.lower_than(current_user.user_roles.map(&:role))
  end

  # session role is being downgraded for the logged-in user
  def update
    update_session_role(params[:user_role][:role_id])
    flash[:notice] = "Current session now has #{Role.find(params[:user_role][:role_id]).name} role"
    redirect_to new_authengine_session_path
  end

protected

  def update_session_role(role_id)
    session[:role].current_role_ids = []
    session[:role].create(role_id.to_i)
  end
end
