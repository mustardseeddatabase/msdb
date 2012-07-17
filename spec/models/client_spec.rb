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
  it "should return the name of the age group of the client in the infants range" do
    client = FactoryGirl.build(:client, :birthdate => 1.years.ago)
    client.age_group.should == "infant"
  end
  it "should return the name of the age group of the client in the infants range" do
    client = FactoryGirl.build(:client, :birthdate => 5.years.ago)
    client.age_group.should == "infant"
  end
  it "should return the name of the age group of the client in the youth range" do
    client = FactoryGirl.build(:client, :birthdate => 6.years.ago)
    client.age_group.should == "youth"
  end
  it "should return the name of the age group of the client in the youth range" do
    client = FactoryGirl.build(:client, :birthdate => 17.years.ago)
    client.age_group.should == "youth"
  end
  it "should return the name of the age group of the client in the adult range" do
    client = FactoryGirl.build(:client, :birthdate => 18.years.ago)
    client.age_group.should == "adult"
  end
  it "should return the name of the age group of the client in the adult range" do
    client = FactoryGirl.build(:client, :birthdate => 64.years.ago)
    client.age_group.should == "adult"
  end
  it "should return the name of the age group of the client in the senior adult range" do
    client = FactoryGirl.build(:client, :birthdate => 65.years.ago)
    client.age_group.should == "senior adult"
  end
  it "should return the name of the age group of the client in the senior adult range" do
    client = FactoryGirl.build(:client, :birthdate => 74.years.ago)
    client.age_group.should == "senior adult"
  end
  it "should return the name of the age group of the client in the senior range" do
    client = FactoryGirl.build(:client, :birthdate => 75.years.ago)
    client.age_group.should == "elder"
  end
  it "should return an out of range indication if there is anomalous data and client age is negative" do
    client = FactoryGirl.build(:client, :birthdate => 1.year.from_now)
    client.age_group.should == "out of range"
  end
  it "should return an out of range indication if there is anomalous data and client age is > 120" do
    client = FactoryGirl.build(:client, :birthdate => 121.years.ago)
    client.age_group.should == "out of range"
  end
  it "should return 'unknown' if the birthdate is nil" do
    client = FactoryGirl.build(:client, :birthdate => nil)
    client.age_group.should == "unknown"
  end
end

describe "id_qualification_vector" do
  it "should have keys client_url, client_name" do
    client = FactoryGirl.build(:client_with_current_id)
    keys = client.id_qualification_vector.keys
    ['client_url', 'client_name'].each do |k|
      keys.should include(k)
    end
  end
end
