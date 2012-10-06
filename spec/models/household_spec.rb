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
    let(:perm_address) { FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835') }
    let(:household) { FactoryGirl.create(:household_with_docs, :perm_address => perm_address) }
    subject { Household.with_address_matching(:perm, @search_obj) }

    context "when the clients match the client_name" do
      before do
        household.clients << FactoryGirl.create(:client, :lastName => 'Cameron')
        @search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'cam')
      end
      it { should == [household] }
    end

    context "when the clients do not match the client_name" do
      before do
        household.clients << FactoryGirl.create(:client, :lastName => 'Clegg')
        @search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'cam')
      end
      it { should be_empty }
    end

    context "when the household matches except for matching the client_name" do
      before do
        household.clients << FactoryGirl.create(:client, :lastName => 'Cameron')
        @search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'foo')
      end
      it { should be_empty }
    end

    context "when the household matches but it has NULL for client last names, and a client_name is present" do
      before do
        household.clients << FactoryGirl.create(:client_with_blank_lastName)
        @search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => 'foo')
      end
      it { should be_empty }
    end
  end

  describe "when the target household does not have clients" do
    it "should return records when the household has no clients, and no client names are passed in" do
      perm_address = FactoryGirl.create(:perm_address, :address => '112 The Highway', :city => 'London', :zip => '83835')
      household = FactoryGirl.create(:household_with_docs)
      household.perm_address = perm_address
      household.save
      search_obj = HouseholdSearch.new(:city => 'lon', :zip => '8', :address => 'high', :client_name => '')
      Household.with_address_matching(:perm, search_obj).should == [household]
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

describe "#distribution_color_code" do
  let(:household) { FactoryGirl.build(:household_with_docs) }
  let(:client) { FactoryGirl.build(:client) }
  subject { household.distribution_color_code }

  context "when there are zero clients" do
    it { should =='' }
  end

  context "when the number of clients is 1" do
    before { household.clients << client }
    it { should =='red' }
  end

  context "when the number of clients is > 6" do
    before { 10.times{household.clients << client } }
    it { should =='gray' }
  end

end

describe "#qualification" do
  let(:household) { FactoryGirl.create(:household_with_docs) }

  it "should return an array of household document qualification vectors" do
    household.qualification.should be_kind_of(Array)
    ["res", "gov", "inc"].each do |type|
      household.qualification.map{|q| q[:doctype] }.should include(type)
    end
  end
end

describe "#with_errors method" do
  subject { household.with_errors }

  context "should return true if any of the associated clients has errors" do
    let(:household) { FactoryGirl.build(:household_with_docs) }
    let(:client) { FactoryGirl.build(:client_with_expired_id) }
    before { household.clients << client }
    it { should == true }
  end

  context "should return true if the household is not current for res, gov or inc attributes" do
    let(:household) { FactoryGirl.build(:household_with_expired_docs) }
    it { should == true }
  end

  context "should return false if all clients are current and res, gov and inc are current" do
    let(:household) { FactoryGirl.build(:household_with_current_docs) }
    let(:client) { FactoryGirl.build(:client_with_current_id) }
    before { household.clients << client }
    it { should == false }
  end
end

describe "#has_head? method" do
  let(:head){ FactoryGirl.build(:client, :headOfHousehold => true) }
  let(:not_head){ FactoryGirl.build(:client, :headOfHousehold => false) }
  let(:household){ FactoryGirl.build(:household) }
  subject{ household.has_head? }

  context "when one of the residents is designated as head of household" do
    before { household.clients << head << not_head }
    it { should == true }
  end

  context "when none of the residents is designated as head of household" do
    before { household.clients << not_head << not_head }
    it { should == false }
  end
end

describe "#has_no_head?" do
  let(:head){ FactoryGirl.build(:client, :headOfHousehold => true) }
  let(:not_head){ FactoryGirl.build(:client, :headOfHousehold => false) }
  let(:household){ FactoryGirl.build(:household) }
  subject{ household.has_no_head? }

  context "when one of the residents is designated as head of household" do
    before { household.clients << head << not_head }
    it { should == false }
  end

  context "when none of the residents is designated as head of household" do
    before { household.clients << not_head << not_head }
    it { should == true }
  end
end

describe "#has_single_head? method" do
  let(:head){ FactoryGirl.build(:client, :headOfHousehold => true) }
  let(:not_head){ FactoryGirl.build(:client, :headOfHousehold => false) }
  let(:household){ FactoryGirl.build(:household) }
  subject{ household.has_single_head? }

  context "when one of the residents is designated as head of household" do
    before { household.clients << head << not_head }
    it { should == true }
  end

  context "when none of the residents is designated as head of household" do
    before { household.clients << not_head << not_head }
    it { should == false }
  end
end

describe "#has_multiple_heads?" do
  let(:head){ FactoryGirl.build(:client, :headOfHousehold => true) }
  let(:not_head){ FactoryGirl.build(:client, :headOfHousehold => false) }
  let(:household){ FactoryGirl.build(:household) }
  subject{ household.has_multiple_heads? }

  context "when all of the residents are designated as head of household" do
    before { household.clients << head << head }
    it { should == true }
  end

  context "when one of the residents is designated as head of household" do
    before { household.clients << head << not_head }
    it { should == false }
  end

  context "when none of the residents is designated as head of household" do
    before { household.clients << not_head << not_head }
    it { should == false }
  end
end

describe "#has_head" do
  let(:head){ FactoryGirl.build(:client, :headOfHousehold => true) }
  let(:not_head){ FactoryGirl.build(:client, :headOfHousehold => false) }
  let(:household){ FactoryGirl.build(:household) }
  subject{ household.has_head? }

  context "when one of the residents is designated as head of household" do
    before { household.clients << head << not_head }
    it { should == true }
  end

  context "when none of the residents is designated as head of household" do
    before { household.clients << not_head << not_head }
    it { should == false }
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

describe "#family_structure" do
  subject { @household.family_structure }
  let(:resident){ FactoryGirl.build(:client) }
  let(:adult){ FactoryGirl.build(:client, :adult) }
  let(:adult_male){ FactoryGirl.build(:client, :adult, :male) }
  let(:adult_female){ FactoryGirl.build(:client, :adult, :female) }
  let(:youth){ FactoryGirl.build(:client, :youth) }

  context "if there is exactly 1 client" do
    before do
      @household = FactoryGirl.build(:household, :clients => [resident])
    end

    it { should == 'one person household' }
  end

  context "when  number of adults = 1, the adult is male, and number of children >= 1" do
    before do
      @household = FactoryGirl.build(:household, :clients => [adult_male, youth])
    end

    it { should == 'single male parent' }
  end

  context "when number of adults = 1, the adult is female, and number of children >= 1" do
    before do
      @household = FactoryGirl.build(:household, :clients => [adult_female, youth])
    end

    it { should == 'single female parent' }
  end

  context "when number of adults = 2, and number of children >= 1" do
    before do
      @household = FactoryGirl.build(:household, :clients => [adult, adult, youth])
    end

    it { should == 'couple w/ children' }
  end

  context "when number of adults = 2, and number of children = 0" do
    before do
      @household = FactoryGirl.build(:household, :clients => [adult, adult])
    end

    it { should == 'couple w/o children' }
  end
end
