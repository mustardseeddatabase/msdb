require 'spec_helper'
require 'ruby-debug'

describe "when permanent address matches the search criteria" do
  before(:each) do
    perm_address = Factory.build(:perm_address, :address => '1234 Redwood Highway', :city => 'Clarksville', :zip => '12345')
    temp_address = Factory.build(:temp_address)
    @household = Factory.build(:household_with_docs)
    @household.perm_address = perm_address
    @household.temp_address = temp_address
    @household.map_address_from('perm_address')
  end

  it "should return the permanent city as address.city" do
    @household.city.should == "Clarksville"
  end

  it "should return the permanent address as address.address" do
    @household.address.should == "1234 Redwood Highway"
  end

  it "should return the permanent zip as address.zip" do
    @household.zip.should == "12345"
  end
end

describe "when temporary address matches the search criteria" do
  before(:each) do
    temp_address = Factory.build(:temp_address, :address => '1234 Redwood Highway', :city => 'Clarksville', :zip => '12345')
    perm_address = Factory.build(:perm_address)
    @household = Factory.build(:household_with_docs)
    @household.perm_address = perm_address
    @household.temp_address = temp_address
    @household.map_address_from('temp_address')
  end

  it "should return the temporary city as address.city" do
    @household.city.should == "Clarksville"
  end

  it "should return the temporary address as address.address" do
    @household.address.should == "1234 Redwood Highway"
  end

  it "should return the temporary zip as address.zip" do
    @household.zip.should == "12345"
  end

  it "should return 'Redwood Highway' as the street name" do
    @household.street_name.should == 'Redwood Highway'
  end

  it "should return '1234' as the street number" do
    @household.street_number.should == 1234
  end
end

describe "when temporary address with a po box matches the search criteria" do
  before(:each) do
    temp_address = Factory.build(:temp_address, :address => 'po box 1234', :city => 'Clarksville', :zip => '12345')
    perm_address = Factory.build(:perm_address)
    @household = Factory.build(:household_with_docs)
    @household.perm_address = perm_address
    @household.temp_address = temp_address
    @household.map_address_from('temp_address')
  end

  it "should return true as address.has_po_box?" do
    @household.has_po_box?.should == true
  end

  it "should return 1 as address.has_po_box" do
    @household.has_po_box.should == 1
  end

  it "should return 1234 as address.po_box_number" do
    @household.po_box_number.should == "1234"
  end

  it "should return blank string as the street name" do
    @household.street_name.should == ''
  end

  it "should return 0 as the street number" do
    @household.street_number.should == 0
  end

end
