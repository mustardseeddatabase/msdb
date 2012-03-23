require 'spec_helper'

describe "#complete? method" do
  before(:each) do
    @address = Factory :address
  end

  it "should be true if address, city and zip are not nil" do
    @address.complete?.should be_true
  end

  it "should be false if address is nil" do
    @address.address = nil
    @address.complete?.should be_false
  end

  it "should be false if city is nil" do
    @address.city = nil
    @address.complete?.should be_false
  end

  it "should be false if zip is nil" do
    @address.zip = nil
    @address.complete?.should be_false
  end
end

describe "zip_codes_matching() method" do
  before(:each) do
    2.times {(1..5).each {|i| 
      Factory.create(:address, :zip => "7000#{i}")
    }}
    (6..9).each {|i| 
      Factory.create(:address, :zip => "8000#{i}")
    }
  end

  it "should return zipcodes from 70001 to 70005, when the argument is 700" do
    Address.zip_codes_matching(700).should == (70001..70005).to_a.map(&:to_s)
    Address.zip_codes_matching(700).size.should == 5
  end

  it "should return zipcodes from 80006 to 80009, when the argument is 800" do
    Address.zip_codes_matching(800).should == (80006..80009).to_a.map(&:to_s)
  end
end

describe "cities_matching() method" do
  before(:each) do
    Factory.create(:address, :city => 'London')
    Factory.create(:address, :city => 'Paris')
  end

  it "should return London when the argument is 'Lon'" do
    Address.cities_matching('Lon').should == ["London"]
  end
end

describe "street_names_matching() method" do
  before(:each) do
    Factory.create(:address, :address => '11155 Champs Elysees')
    Factory.create(:address, :address => '14332 Champs Elysees')
    Factory.create(:address, :address => '83422 Champion Avenue')
    Factory.create(:address, :address => '23234 Boulevard Saint Michel')
  end

  it "should return Champs Elsysees when the argument is 'Cha'" do
    Address.street_names_matching('Cha').size.should == 2
    Address.street_names_matching('Cha').should include("Champs Elysees")
    Address.street_names_matching('Cha').should include("Champion Avenue")
  end
end

describe "named scope 'matching'" do
  describe "when only partial street name is passed-in" do
    before(:each) do
      @address = Factory.create(:address, :address => '1245 Champs Elysees')
      Factory.create(:address, :address => '1245 Chomps Elysees')
      Factory.create(:address)
    end

    it "should return matching addresses" do
      results = Address.matching({:city => '', :address =>'cha', :zip =>''})
      results.size.should ==1
      results.should ==[@address]
    end
  end

  describe "when only partial city is passed-in" do
    before(:each) do
      @address1 = Factory.create(:address, :city => 'Paris Texas')
      @address2 = Factory.create(:address, :city => 'Paris Hilton')
      Factory.create(:address)
    end

    it "should return matching addresses" do
      results = Address.matching({:city => 'par', :street_name =>'', :zip =>''})
      results.size.should ==2
      results.should include(@address1)
      results.should include(@address2)
    end
  end

  describe "when only partial zip is passed-in" do
    before(:each) do
      @address1 = Factory.create(:address, :zip => '70001')
      @address2 = Factory.create(:address, :zip => '70055')
      Factory.create(:address)
    end

    it "should return matching addresses" do
      results = Address.matching({:city => '', :street_name =>'', :zip =>'700'})
      results.size.should ==2
      results.should include(@address1)
      results.should include(@address2)
    end
  end

  describe "when two parameters are passed in" do
    before(:each) do
      @address1 = Factory.create(:address, :zip => '70001', :address => '10588 Elysian Fields')
      @address2 = Factory.create(:address, :zip => '80001', :address => '10588 Elysian Fields')
      Factory.create(:address)
    end

    it "should return matching addresses" do
      results = Address.matching({:city => '', :street_name =>'ian', :zip =>'700'})
      results.size.should ==1
      results.should ==[@address1]
    end
  end
end

describe "has_po_box methd" do
  it "should respond with 1 to has_po_box method with upper case letters" do
    @perm_address = Factory.build(:perm_address, :address => 'PO Box 888')
    @perm_address.has_po_box.should ==1
  end

  it "should respond with 1 to has_po_box method with spaces between letters" do
    @perm_address = Factory.build(:perm_address, :address => 'P O Box 888')
    @perm_address.has_po_box.should ==1
  end

  it "should respond with 1 to has_po_box method with periods between letters" do
    @perm_address = Factory.build(:perm_address, :address => 'P.O. Box 888')
    @perm_address.has_po_box.should ==1
  end
end

describe "the po box number method" do
  it "should return the po box number" do
    @perm_address = Factory.build(:perm_address, :address => 'PO box 137')
    @perm_address.po_box_number.should =='137'
  end

  it "should return the po box number with alternative format" do
    @perm_address = Factory.build(:perm_address, :address => 'P. O. box 137')
    @perm_address.po_box_number.should =='137'
  end

  it "should return the po box number with another alternative format" do
    @perm_address = Factory.build(:perm_address, :address => 'P. O.  137')
    @perm_address.po_box_number.should =='137'
  end

  it "should return an empty string when there's no po box number" do
    @perm_address = Factory.build(:perm_address, :address => '88 Sunset Strip')
    @perm_address.po_box_number.should ==''
  end

end

describe "street_name method" do
  it "should return the street name" do
    perm_address = Factory.build(:perm_address, :address => '567 Rue Morgue')
    perm_address.street_name.should =='Rue Morgue'
  end

  it "should return a blank string if there's no street name" do
    perm_address = Factory.build(:perm_address, :address => 'PO box 777')
    perm_address.street_name.should ==''
  end

  it "should return a blank string if the address is a blank string" do
    perm_address = Factory.build(:perm_address, :address => '')
    perm_address.street_name.should ==''
  end

  it "should return a blank string if the address is nil" do
    perm_address = Factory.build(:perm_address, :address => nil)
    perm_address.street_name.should ==''
  end
end

describe "street_number method" do
  it "should return the numeric part of the street address" do
    perm_address = Factory.build(:perm_address, :address => '888 Starlight Boulevard')
    perm_address.street_number.should ==888
  end

  it "should return zero for a po box" do
    perm_address = Factory.build(:perm_address, :address => 'PO Box 111')
    perm_address.street_number.should ==0
  end

  it "should return zero if the first chars are not digits" do
    perm_address = Factory.build(:perm_address, :address => "#44 Sunshine Avenue")
    perm_address.street_number.should ==0
  end

  it "should return zero if the address is blank" do
    perm_address = Factory.build(:perm_address, :address => nil)
    perm_address.street_number.should ==0
  end
end

describe "#street_number method" do
  it "should return the leading numeric part of the address" do
    address = Factory.build(:address, :address => '4135 Burnside Road')
    address.street_number.should == 4135
  end

  it "should return a blank string if there is no leading numeric part of the address" do
    address = Factory.build(:address, :address => 'Burnside Road')
    address.street_number.should == 0
  end
end
