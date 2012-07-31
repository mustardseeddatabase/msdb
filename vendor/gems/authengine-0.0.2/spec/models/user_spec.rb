require 'spec_helper'

describe "when a new user is added" do
  before(:each) do
    user = FactoryGirl.create(:user)
  end

  it "a registration email should be sent" do
    ActionMailer::Base.deliveries.size.should == 1
  end

  it "email should have 'Please activate' etc in subject" do
    ActionMailer::Base.deliveries.last.subject.should == "Test database - Please activate your new account"
  end
end

