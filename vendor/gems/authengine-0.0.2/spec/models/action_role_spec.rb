require File.expand_path("../../spec_helper", __FILE__)


describe 'permits_access_for class method' do
  before(:each) do
    @role        = Role.create(:name => 'chief')
    @controller  = Controller.create(:controller_name => 'traveller')
    @action      = Action.create(:action_name => 'travel', :controller_id => @controller.id)
    @user        = FactoryGirl.create(:user, :login => 'just_me')
    @user_role   = UserRole.create(:role_id => @role.id, :user_id => @user.id)
    @action_role = ActionRole.create(:action_id => @action.id, :role_id => @role.id)
  end

  it "action is permitted for user's role" do
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, @user.roles(true).map(&:id)).should == true
  end

  it "action is not permitted for user's role" do
    ActionRole.permits_access_for(@controller.controller_name, 'some_action', @user.roles(true).map(&:id)).should == false
  end

  it "different user tries to access the action" do
    @user = FactoryGirl.create(:user, :login => 'another_person')
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, @user.roles.map(&:id)).should == false
  end

  it "user has a role that does not permit access to the requested action" do
    UserRole.delete_all
    @user_role  = UserRole.create(:role_id => 555, :user_id => @user.id)
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, @user.user_roles.map(&:role_id)).should == false
  end

  it "user's role does not permit access to the requested action" do
    ActionRole.delete_all
    @action_role = ActionRole.create(:action_id => @action.id, :role_id => 555)
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, @user.roles(true).map(&:id)).should == false
  end
end

describe "permits_access_for class method" do
  before(:each) do
    @role         = Role.create(:name => 'chief')
    @another_role = Role.create(:name => 'minion')
    @controller   = Controller.create(:controller_name => 'traveller')
    @action       = Action.create(:action_name => 'travel', :controller_id => @controller.id)
    @user         = FactoryGirl.create(:user, :login => 'just_me')
    @action_role  = ActionRole.create(:action_id => @action.id, :role_id => @role.id)
  end

  it "should permit when one of the passed-in roles has an action_role that links to the passed in controller/action" do
    role_ids = [@role.id]
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, role_ids).should == true
  end

  it "should not permit when none of the passed-in roles has an action role for the passed-in controller/action" do
    role_ids = [@another_role.id]
    ActionRole.permits_access_for(@controller.controller_name, @action.action_name, role_ids).should == false
  end
end
