require 'spec_helper'

describe "lastNames_matching() class method" do
  it "should return clients with last name matching the argument" do
    FactoryGirl.create(:client, :lastName => 'Arbogast')
    FactoryGirl.create(:client, :lastName => 'Gaston')
    FactoryGirl.create(:client, :lastName => 'Bullwinkel')
    Client.lastNames_matching('gas').should == ['Arbogast', 'Gaston']
  end
end

describe "lastNames_matching_extended() class method" do
  it "should return clients with last name matching the argument" do
    FactoryGirl.create(:client, :lastName => 'Arbogast', :firstName => 'Fanny', :birthdate => 20.years.ago)
    gary = FactoryGirl.create(:client, :lastName => 'Gaston', :firstName => 'Gary', :birthdate => 5.years.ago)
    gary.update_attribute(:birthdate, nil) # to make birthdate nil without validation error
    FactoryGirl.create(:client, :lastName => 'Bullwinkel')
    Client.lastNames_matching_extended('gas').first.should =~ /Arbogast, Fanny\. 20\|(\d*)/
    Client.lastNames_matching_extended('gas').last.should =~ /Gaston, Gary\|(\d*)/
  end
end

describe "#id_current? method" do
  it "should return true if the associated id_qualdoc #current? method returns true" do
    c = FactoryGirl.build(:client_with_current_id)
    c.id_current?.should ==true
  end

  it "should return false if the associated id_qualdoc #current? method returns false" do
    c = FactoryGirl.build(:client_with_expired_id)
    c.id_current?.should ==false
  end
end

describe "#is_sole_head_of_household?" do
  before(:all) do
    @hh = FactoryGirl.build(:household)
    @c1 = FactoryGirl.build(:client, :household => @hh, :headOfHousehold => true)
    @c2 = FactoryGirl.build(:client, :household => @hh, :headOfHousehold => false)
    @hh.clients << @c1
    @hh.clients << @c2
  end

  it "should return true if the client is the sold head of household" do
    @c1.is_sole_head_of_household?.should == true
  end

  it "should return false if the client is not head of household" do
    @c2.is_sole_head_of_household?.should == false
  end

  it "should return false if the client is one of many heads of household" do
    c3 = FactoryGirl.build(:client, :household => @hh, :headOfHousehold => true)
    @hh.clients << c3
    c3.is_sole_head_of_household?.should == false
  end
end

describe "age_group" do
  it "should return the name of the age group of the client in the child range" do
    client = FactoryGirl.build(:client, :birthdate => 10.years.ago)
    client.age_group.should == "child"
  end
  it "should return the name of the age group of the client in the adult range" do
    client = FactoryGirl.build(:client, :birthdate => 20.years.ago)
    client.age_group.should == "adult"
  end
  it "should return the name of the age group of the client in the senior range" do
    client = FactoryGirl.build(:client, :birthdate => 80.years.ago)
    client.age_group.should == "senior"
  end
end
