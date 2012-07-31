require File.expand_path("../../spec_helper", __FILE__)

describe "user factory" do
  it "should generate a valid user, with a valid activated_at date" do
    FactoryGirl.build(:user).activated_at.to_date.year.should < 2020
  end
end
