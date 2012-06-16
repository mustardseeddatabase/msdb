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
  it "should return a hash of household and client qualification vectors" do
    household = FactoryGirl.create(:household_with_docs)
    client1 = FactoryGirl.build(:client, :household_id => household.id)
    client2 = FactoryGirl.build(:client, :household_id => household.id)
    household.qualification.should be_kind_of(Hash)
    household.qualification.size.should ==2 # :household and :clients
    [:household, :clients].each do |type|
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

describe 'counts_by_age_group' do
  context 'when the household does not have any clients' do
    before(:each) do
      @household = FactoryGirl.create(:household)
      @counts = @household.counts_by_age_group
    end

    it "should return a hash" do
      @counts.should be_kind_of(Hash)
    end

    it "should have keys :children, :adults, :seniors" do
      @counts.keys.should include(:children)
      @counts.keys.should include(:adults)
      @counts.keys.should include(:seniors)
    end

    it "should count clients by age group" do
      @counts[:children].should == 0
      @counts[:adults].should == 0
      @counts[:seniors].should == 0
    end
  end

  context 'when the household has clients' do
    before(:each) do
      @client1 = FactoryGirl.create(:client, :birthdate => 10.years.ago)
      @client2 = FactoryGirl.create(:client, :birthdate => 20.years.ago)
      @client3 = FactoryGirl.create(:client, :birthdate => 80.years.ago)
      @client4 = FactoryGirl.create(:client, :birthdate => 10.years.ago)
      @client5 = FactoryGirl.create(:client, :birthdate => 20.years.ago)
      @household = FactoryGirl.create(:household)
      @household.clients = [@client1, @client2, @client3, @client4, @client5]
      @counts = @household.counts_by_age_group
    end

    it "should return a hash" do
      @counts.should be_kind_of(Hash)
    end

    it "should have keys :children, :adults, :seniors" do
      @counts.keys.should include(:children)
      @counts.keys.should include(:adults)
      @counts.keys.should include(:seniors)
    end

    it "should count clients by age group" do
      @counts[:children].should == 2
      @counts[:adults].should == 2
      @counts[:seniors].should == 1
    end
  end

  context 'when some clients have null birthdate' do
    before(:each) do
      @client1 = FactoryGirl.create(:client, :birthdate => 10.years.ago)
      @client1.update_attribute(:birthdate, nil)
      @client2 = FactoryGirl.create(:client, :birthdate => 20.years.ago)
      @client3 = FactoryGirl.create(:client, :birthdate => 80.years.ago)
      @client4 = FactoryGirl.create(:client, :birthdate => 10.years.ago)
      @client5 = FactoryGirl.create(:client, :birthdate => 20.years.ago)
      @household = FactoryGirl.create(:household)
      @household.clients  << @client1
      @household.clients  << @client2
      @household.clients  << @client3
      @household.clients  << @client4
      @household.clients  << @client5
      @counts = @household.counts_by_age_group
    end

    it "should return a hash" do
      @counts.should be_kind_of(Hash)
    end

    it "should have keys :children, :adults, :seniors" do
      @counts.keys.should include(:children)
      @counts.keys.should include(:adults)
      @counts.keys.should include(:seniors)
    end

    it "should count clients by age group" do
      @counts[:children].should == 1
      @counts[:adults].should == 2
      @counts[:seniors].should == 1
    end
  end
end

describe 'counts_by_race' do
  context "when the household does not have any clients" do
    before(:each) do
      @household = FactoryGirl.create(:household)
      @counts = @household.counts_by_race
    end

    it "should return a hash" do
      @counts.should be_kind_of(Hash)
    end

    it "should have keys :AA, :AS, :HI, :WH, :UNK, :total" do
      @counts.keys.should include(:AA)
      @counts.keys.should include(:AS)
      @counts.keys.should include(:HI)
      @counts.keys.should include(:WH)
      @counts.keys.should include(:UNK)
      @counts.keys.should include(:total)
    end

    it "should count clients by race" do
      @counts[:AA].should == 0
      @counts[:AS].should == 0
      @counts[:HI].should == 0
      @counts[:WH].should == 0
      @counts[:UNK].should == 0
      @counts[:total].should == 0
    end
  end

  context "when the household has clients" do
    before(:each) do
      @client1 = FactoryGirl.create(:client, :race => 'AA')
      @client2 = FactoryGirl.create(:client, :race => 'AS')
      @client3 = FactoryGirl.create(:client, :race => 'HI')
      @client4 = FactoryGirl.create(:client, :race => 'WH')
      @client5 = FactoryGirl.create(:client, :race => 'OT')
      @client6 = FactoryGirl.create(:client, :race => nil)
      @household = FactoryGirl.create(:household)
      @household.clients = [@client1, @client2, @client3, @client4, @client5, @client6]
      @counts = @household.counts_by_race
    end

    it "should return a hash" do
      @counts.should be_kind_of(Hash)
    end

    it "should have keys :AA, :AS, :HI, :WH, :UNK, :total" do
      @counts.keys.should include(:AA)
      @counts.keys.should include(:AS)
      @counts.keys.should include(:HI)
      @counts.keys.should include(:WH)
      @counts.keys.should include(:UNK)
      @counts.keys.should include(:total)
    end

    it "should count clients by race" do
      @counts[:AA].should == 1
      @counts[:AS].should == 1
      @counts[:HI].should == 1
      @counts[:WH].should == 1
      @counts[:UNK].should == 2
      @counts[:total].should == 6
    end

    it "should have equal totals by race and by age" do
      count_by_age_group = @counts.slice([:children, :adults, :seniors, :homeless]).values.flatten.count
      count_by_race = @counts.slice([:AA, :AS, :HI, :WH, :OT]).values.flatten.count
      count_by_age_group.should == count_by_race
    end
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

