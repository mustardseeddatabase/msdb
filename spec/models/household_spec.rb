require 'spec_helper'
require 'ruby-debug'

describe "#has_full_perm_or_temp_address? method" do
  it "should be true if there is one associated address complete" do
    household = FactoryGirl.build(:household_with_docs)
    household.has_full_perm_or_temp_address?.should be_true
  end

  it "should be false if there are no associated addresses" do
    household = FactoryGirl.build(:household_with_docs)
    household.perm_address = nil
    household.temp_address = nil
    household.has_full_perm_or_temp_address?.should be_false
  end

  it "should be false if all associated addresses are not complete" do
    perm_address = FactoryGirl.build(:perm_address, :address => '')
    temp_address = FactoryGirl.build(:temp_address, :zip => '')
    household = FactoryGirl.build(:household_with_docs)
    household.perm_address = perm_address
    household.temp_address = temp_address
    household.has_full_perm_or_temp_address?.should be_false
  end
end

describe "scope: with_address_matching" do
  describe "when the target household has clients" do
    it "should return records where the clients match the client_name" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs)
      household.perm_address = perm_address
      household.save
      client = FactoryGirl.create(:client, :lastName => 'Cameron')
      household.clients << client
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'cam')
      result = Household.with_address_matching(:perm, search_obj)
      result.size.should == 1
      result.first.id.should ==household.id
    end

    it "should not return records where the clients do not match the client_name" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs, :perm_address_id => perm_address.id)
      client = FactoryGirl.create(:client, :lastName => 'Clegg', :household_id => household.id)
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'cam')
      Household.with_address_matching(:perm, search_obj).should be_empty
    end

    it "should not return any records when the household matches except for matching the client_name" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs, :perm_address_id => perm_address.id)
      client = FactoryGirl.create(:client, :lastName => 'Cameron', :household_id => household.id)
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'foo')
      Household.with_address_matching(:perm, search_obj).should be_empty
    end

    it "should not return any records when the household matches but it has NULL for client last names, and a client_name is present" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs, :perm_address_id => perm_address.id)
      client = FactoryGirl.build(:client, :lastName => nil, :household_id => household.id)
      client.save # avoids validation failure due to blank lastName
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'foo')
      Household.with_address_matching(:perm, search_obj).should be_empty
    end
  end

  describe "when the target household does not have clients" do
    it "should return records when the household has no clients, and no client names are passed in" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs)
      household.perm_address = perm_address
      household.save
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => '')
      Household.with_address_matching(:perm, search_obj).should_not be_empty
      Household.with_address_matching(:perm, search_obj).first.id.should == household.id
    end

    it "should not return any records when the household has no clients, and client names are passed in" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs, :perm_address_id => perm_address.id)
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'cam')
      Household.with_address_matching(:perm, search_obj).should be_empty
    end
  end
end

describe "named scope 'with_perm_address_matching'" do
  describe "when only partial street name is passed-in" do
    it "should return matching household" do
      perm_address = FactoryGirl.create(:perm_address, :address => '1245 Champs Elysees')
      household = FactoryGirl.create(:household_with_docs)
      household.perm_address = perm_address
      household.save
      search_obj = HouseholdSearch.new(:city => '', :address =>'cha', :zip =>'')
      results = Household.with_address_matching(:perm, search_obj)
      results.should ==[household]
    end
  end

  describe "when only partial city is passed-in" do
    before(:each) do
      perm_address = FactoryGirl.create(:perm_address, :city => 'Paris Texas')
      @household = FactoryGirl.create(:household_with_docs)
      @household.perm_address = perm_address
      @household.save
    end

    it "should return matching addresses" do
      search_obj = HouseholdSearch.new(:city => 'par', :address =>'', :zip =>'')
      results = Household.with_address_matching(:perm, search_obj)
      results.should include(@household)
    end
  end

  describe "when only partial zip is passed-in" do
    before(:each) do
      perm_address = FactoryGirl.create(:perm_address, :zip => '70001')
      @household = FactoryGirl.create(:household_with_docs)
      @household.perm_address = perm_address
      @household.save
    end

    it "should return matching households" do
      search_obj = HouseholdSearch.new(:city => '', :address =>'', :zip =>'700')
      results = Household.with_address_matching(:perm, search_obj)
      results.should include(@household)
    end

  end

  describe "when two parameters are passed in" do
    before(:all) do
      perm_address1 = FactoryGirl.create(:perm_address, :zip => '70001', :address => '10588 Elysian Fields')
      perm_address2 = FactoryGirl.create(:perm_address, :zip => '80001', :address => '10588 Elysian Fields')
      @household1 = FactoryGirl.create(:household_with_docs)
      @household1.perm_address = perm_address1
      @household1.save
      @household2 = FactoryGirl.create(:household_with_docs)
      @household2.perm_address = perm_address2
      @household2.save
      search_obj = HouseholdSearch.new(:city => '', :address =>'ian', :zip =>'700')
      @results = Household.with_address_matching(:perm, search_obj)
    end

    it "should return matching households" do
      @results.size.should ==1
      @results.should ==[@household1]
    end

    it "should populate the city/address/zip fields" do
      @results.each{|r| r.map_address_from(:perm_address)}
      @results.first.zip.should =='70001'
      @results.first.address.should =='10588 Elysian Fields'
    end
  end
end

describe "#map_address_from method" do
  it "should map permanent address attributes when the passed-in parameter is :perm_address" do
    household = FactoryGirl.build(:household_with_docs)
    household.city.should be_nil
    household.address.should be_nil
    household.zip.should be_nil
    household.map_address_from(:perm_address)
    household.city.should == household.permanent_city
    household.address.should == household.permanent_address
    household.zip.should == household.permanent_zip
  end

  it "should map temporary address attributes when the passed-in parameter is :temp" do
    temp_address = FactoryGirl.create(:temp_address)
    household = FactoryGirl.build(:household_with_docs, :temp_address_id => temp_address.id)
    household.city.should be_nil
    household.address.should be_nil
    household.zip.should be_nil
    household.map_address_from(:temp_address)
    household.city.should == household.temporary_city
    household.address.should == household.temporary_address
    household.zip.should == household.temporary_zip
  end
end

describe "color method" do
  it "should return a blank string if there are zero clients" do
    household = FactoryGirl.build(:household_with_docs)
    household.distribution_color_code.should ==''
  end

  it "should return a color string if the number of clients is 1 to 6" do
    household = FactoryGirl.create(:household_with_docs)
    household.clients << FactoryGirl.create(:client)
    household.distribution_color_code.should =='red'
  end

  it "should return the 6-client code if the number of clients is > 6" do
    household = FactoryGirl.create(:household_with_docs)
    10.times{household.clients << FactoryGirl.create(:client)}
    household.distribution_color_code.should =='gray'
  end

end

describe "qualification" do
  it "should return a hash of household document qualification vectors" do
    household = FactoryGirl.create(:household_with_docs)
    household.qualification.should be_kind_of(Hash)
    household.qualification.size.should ==3 # :household and :clients
    [:res, :gov, :inc].each do |type|
      household.qualification.keys.should include(type)
    end
  end
end

describe "#with_errors method" do
  it "should return true if any of the associated clients has errors" do
    household = FactoryGirl.create(:household_with_docs)
    client = FactoryGirl.build(:client_with_expired_id,
                           :household_id => household.id)
    household.with_errors.should == true
  end

  it "should return true if the household is not current for res, gov or inc attributes" do
    household = FactoryGirl.create(:household_with_expired_docs)
    household.with_errors.should == true
  end

  it "should return false if all clients are current and res, gov and inc are current" do
    household = FactoryGirl.create(:household_with_current_docs)
    client = FactoryGirl.build(:client_with_current_id,
                           :household_id => household.id)
    household.with_errors.should == false
  end
end

describe "#has_head? method" do
  before(:all) do
    @household = FactoryGirl.build(:household_with_docs)
    @client = FactoryGirl.build(:client, :headOfHousehold => true)
    @household.clients << @client
  end

  it "should be true when one of the residents is designated as head of household" do
    @household.has_head?.should == true
  end

  it "should be false when none of the residents is designated as head of household" do
    @client.headOfHousehold = false
    @household.has_head?.should == false
  end
end

describe "#has_no_head? method" do
  before(:all) do
    @household = FactoryGirl.build(:household_with_docs)
    @client = FactoryGirl.build(:client, :headOfHousehold => false)
    @household.clients << @client
  end

  it "should be true when one of the residents is designated as head of household" do
    @household.has_no_head?.should == true
  end

  it "should be false when none of the residents is designated as head of household" do
    @client.headOfHousehold = true
    @household.has_no_head?.should == false
  end
end

describe "#has_single_head? method" do
  before(:all) do
    @household = FactoryGirl.build(:household_with_docs)
    @client1 = FactoryGirl.build(:client, :headOfHousehold => true)
    @client2 = FactoryGirl.build(:client, :headOfHousehold => false)
    @household.clients << @client1
    @household.clients << @client2
  end

  it "should be true when one of the residents is designated as head of household" do
    @household.has_single_head?.should == true
  end

  it "should be false when none of the residents is designated as head of household" do
    @client1.headOfHousehold = false
    @household.has_single_head?.should == false
  end
end

describe "#has_multiple_heads? method" do
  before(:each) do
    @household = FactoryGirl.create(:household_with_docs)
    @household.res_qualdoc.date = 1.month.ago
    @household.inc_qualdoc.date = 1.month.ago
    @household.gov_qualdoc.date = 1.month.ago
    @client1 = FactoryGirl.build(:client, 
                     :headOfHousehold => true)
    @client2 = FactoryGirl.build(:client, 
                     :headOfHousehold => true)
    @household.clients << @client1
    @household.clients << @client2
  end

  it "should be true when all of the residents are designated as head of household" do
    @household.has_multiple_heads?.should == true
  end

  it "should be false when one of the residents is designated as head of household" do
    @client2.headOfHousehold = false
    @household.has_head?.should == true
    @household.has_multiple_heads?.should == false
  end

  it "should be false when none of the residents is designated as head of household" do
    @client1.headOfHousehold = false
    @client2.headOfHousehold = false
    @household.has_head?.should == false
    @household.has_multiple_heads?.should == false
  end
end


describe "new_or_continued_in_month method" do
  it "should return true if any of the distributions in the month for this household are new" do
    dist1 = FactoryGirl.create(:distribution, :created_at => Date.today)
    @household = FactoryGirl.create(:household, :distributions => [dist1])
    dist1.update_attribute(:household_id, @household.id)
    @household.new_or_continued_in_month(Date.today.year, Date.today.month).should == :new
  end

  it "should return false if all of the distributions in the month for this household are not new" do
    dist1 = FactoryGirl.create(:distribution, :created_at => Date.today)
    dist2 = FactoryGirl.create(:distribution, :created_at => 1.month.ago)
    @household = FactoryGirl.create(:household, :distributions => [dist1, dist2])
    dist1.update_attribute(:household_id, @household.id)
    dist2.update_attribute(:household_id, @household.id)
    @household.new_or_continued_in_month(Date.today.year, Date.today.month).should == :continued
  end
end

describe "ssi? method" do
  it "should return true if ssi field is true" do
    hh = FactoryGirl.build(:household, :ssi => true)
    hh.ssi?.should be_true
  end
end

describe "family_structure method" do
  it "should return 'one person household' if there is exactly 1 client" do
    client1 = FactoryGirl.build(:client)
    household = FactoryGirl.build(:household, :clients => [client1])
    household.family_structure.should == 'one person household'
  end

  it "should return 'single male parent' if # adults = 1, the adult is male, and # children >= 1" do
    client1 = FactoryGirl.build(:client, :adult, :male)
    client2 = FactoryGirl.build(:client, :youth)
    household = FactoryGirl.build(:household, :clients => [client1, client2])
    household.family_structure.should == 'single male parent'
  end

  it "should return 'single female parent' if # adults = 1, the adult is female, and # children >= 1" do
    client1 = FactoryGirl.build(:client, :adult, :female)
    client2 = FactoryGirl.build(:client, :youth)
    household = FactoryGirl.build(:household, :clients => [client1, client2])
    household.family_structure.should == 'single female parent'
  end

  it "should return 'couple w/ children' if # adults = 2, and # children >= 1" do
    client1 = FactoryGirl.build(:client, :adult)
    client2 = FactoryGirl.build(:client, :adult)
    client3 = FactoryGirl.build(:client, :youth)
    household = FactoryGirl.build(:household, :clients => [client1, client2, client3])
    household.family_structure.should == 'couple w/ children'
  end

  it "should return 'couple w/o children' if # adults = 2, and # children = 0" do
    client1 = FactoryGirl.build(:client, :adult)
    client2 = FactoryGirl.build(:client, :adult)
    household = FactoryGirl.build(:household, :clients => [client1, client2])
    household.family_structure.should == 'couple w/o children'
  end
end
