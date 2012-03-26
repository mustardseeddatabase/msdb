require 'spec_helper'
require 'authengine/testing_support/factories/user_factory'

def current_user
  @current_user ||= FactoryGirl.create(:user)
end

describe ApplicationHelper, "current_user_permitted method" do
  before(:each) do
    @user = current_user
    @role = Role.create(:name => 'admin')
    @user.user_roles.create(:role_id => @role.id)
    @controller = Controller.create(:controller_name => 'distributions')
    @action = Action.create(:controller_id => @controller.id, :action_name => 'index')
    @action_role = ActionRole.create(:action_id => @action.id, :role_id => @role.id)
  end

  it "is true when permission is explicitly configured" do
    current_user_permitted?({:controller => 'distributions', :action => 'index'}).should be_true
  end

  it "is false when permission is not explicitly configured" do
    current_user_permitted?({:controller => 'donations', :action => 'index'}).should be_false
  end

  it "is false when permitted for a different user" do
    @current_user = FactoryGirl.create(:user)
    current_user_permitted?({:controller => 'distributions', :action => 'index'}).should be_false
  end

  it "is false when permitted for a different action" do
    current_user_permitted?({:controller => 'distributions', :action => 'show'}).should be_false
  end
end

describe ApplicationHelper, "current_role_permits? method" do
  before(:each) do
    @user = current_user
    @role = Role.create(:name => 'admin')
    @controller = Controller.create(:controller_name => 'distributions')
    @action = Action.create(:controller_id => @controller.id, :action_name => 'index')
    @action_role = ActionRole.create(:action_id => @action.id, :role_id => @role.id)
  end

  it "is true when permission is explicitly configured" do
    #current_role_permits?({:controller => 'distributions', :action => 'index'}).should be_true
  end

  #it "is false when permission is not explicitly configured" do
    #current_role_permits?({:controller => 'donations', :action => 'index'}).should be_false
  #end

  #it "is false when permitted for a different user" do
    #@current_user = FactoryGirl.create(:user)
    #current_role_permits?({:controller => 'distributions', :action => 'index'}).should be_false
  #end

  #it "is false when permitted for a different action" do
    #current_role_permits?({:controller => 'distributions', :action => 'show'}).should be_false
  #end
end
