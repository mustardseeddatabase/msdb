require 'spec_helper'

describe "#complete? method" do
  subject { FactoryGirl.create :address }

  context "when address, city and zip are not nil" do
    its(:complete?) { should be_true }
  end

  context "if address is nil" do
    before { subject.address = nil }
    its(:complete?) { should be_false }
  end

  context "if city is nil" do
    before { subject.city = nil }
    its(:complete?) { should be_false }
  end

  context "if zip is nil" do
    before { subject.zip = nil }
    its(:complete?) { should be_false }
  end
end

describe ".zip_codes_matching()" do
  before(:each) do
    FactoryGirl.create(:address, :zip => "70001")
    FactoryGirl.create(:address, :zip => "80002")
  end

  it "should return zipcode 70001 when the argument is 700" do
    Address.zip_codes_matching(700).should == ["70001"]
  end

  it "should return zipcode 80002 when the argument is 800" do
    Address.zip_codes_matching(800).should == ["80002"]
  end
end

describe "cities_matching() method" do
  before(:each) do
    FactoryGirl.create(:address, :city => 'London')
    FactoryGirl.create(:address, :city => 'Paris')
  end

  it "should return London when the argument is 'Lon'" do
    Address.cities_matching('Lon').should == ["London"]
  end
end

describe "street_names_matching() method" do
  before(:each) do
    FactoryGirl.create(:address, :address => '11155 Champs Elysees')
    FactoryGirl.create(:address, :address => '14332 Champs Elysees')
    FactoryGirl.create(:address, :address => '83422 Champion Avenue')
    FactoryGirl.create(:address, :address => '23234 Boulevard Saint Michel')
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
      @address = FactoryGirl.create(:address, :address => '1245 Champs Elysees')
      FactoryGirl.create(:address, :address => '1245 Chomps Elysees')
      FactoryGirl.create(:address)
    end

    it "should return matching addresses" do
      results = Address.matching({:city => '', :address =>'cha', :zip =>''})
      results.size.should ==1
      results.should ==[@address]
    end
  end

  describe "when only partial city is passed-in" do
    before(:each) do
      @address1 = FactoryGirl.create(:address, :city => 'Paris Texas')
      @address2 = FactoryGirl.create(:address, :city => 'Paris Hilton')
      FactoryGirl.create(:address)
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
      @address1 = FactoryGirl.create(:address, :zip => '70001')
      @address2 = FactoryGirl.create(:address, :zip => '70055')
      FactoryGirl.create(:address)
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
      @address1 = FactoryGirl.create(:address, :zip => '70001', :address => '10588 Elysian Fields')
      @address2 = FactoryGirl.create(:address, :zip => '80001', :address => '10588 Elysian Fields')
      FactoryGirl.create(:address)
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
    @perm_address = FactoryGirl.build(:perm_address, :address => 'PO Box 888')
    @perm_address.has_po_box.should ==1
  end

  it "should respond with 1 to has_po_box method with spaces between letters" do
    @perm_address = FactoryGirl.build(:perm_address, :address => 'P O Box 888')
    @perm_address.has_po_box.should ==1
  end

  it "should respond with 1 to has_po_box method with periods between letters" do
    @perm_address = FactoryGirl.build(:perm_address, :address => 'P.O. Box 888')
    @perm_address.has_po_box.should ==1
  end
end

describe "#po_box_number" do
  context "when po box field is properly formatted" do
    subject(:address) { FactoryGirl.build(:perm_address, :address => 'PO box 137') }
    its(:po_box_number) { should == '137' }
  end

  context "when po box field has periods in format" do
    subject(:address) { FactoryGirl.build(:perm_address, :address => 'P. O. box 137') }
    its(:po_box_number) { should == '137' }
  end

  context "when 'box' is missing from address field" do
    subject(:address) { FactoryGirl.build(:perm_address, :address => 'P. O.  137') }
    its(:po_box_number) { should == '137' }
  end

  context "when the address is not a po box" do
    subject(:address) { FactoryGirl.build(:perm_address, :address => '88 Sunset Strip') }
    its(:po_box_number) { should be_blank }
  end
end

describe "street_name method" do
  it "should return the street name" do
    perm_address = FactoryGirl.build(:perm_address, :address => '567 Rue Morgue')
    perm_address.street_name.should =='Rue Morgue'
  end

  it "should return a blank string if there's no street name" do
    perm_address = FactoryGirl.build(:perm_address, :address => 'PO box 777')
    perm_address.street_name.should ==''
  end

  it "should return a blank string if the address is a blank string" do
    perm_address = FactoryGirl.build(:perm_address, :address => '')
    perm_address.street_name.should ==''
  end

  it "should return a blank string if the address is nil" do
    perm_address = FactoryGirl.build(:perm_address, :address => nil)
    perm_address.street_name.should ==''
  end
end

describe "street_number method" do
  it "should return the numeric part of the street address" do
    perm_address = FactoryGirl.build(:perm_address, :address => '888 Starlight Boulevard')
    perm_address.street_number.should ==888
  end

  it "should return zero for a po box" do
    perm_address = FactoryGirl.build(:perm_address, :address => 'PO Box 111')
    perm_address.street_number.should ==0
  end

  it "should return zero if the first chars are not digits" do
    perm_address = FactoryGirl.build(:perm_address, :address => "#44 Sunshine Avenue")
    perm_address.street_number.should ==0
  end

  it "should return zero if the address is blank" do
    perm_address = FactoryGirl.build(:perm_address, :address => nil)
    perm_address.street_number.should ==0
  end
end

describe "#street_number method" do
  it "should return the leading numeric part of the address" do
    address = FactoryGirl.build(:address, :address => '4135 Burnside Road')
    address.street_number.should == 4135
  end

  it "should return a blank string if there is no leading numeric part of the address" do
    address = FactoryGirl.build(:address, :address => 'Burnside Road')
    address.street_number.should == 0
  end
end
