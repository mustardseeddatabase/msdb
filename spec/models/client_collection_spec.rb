require 'spec_helper'

describe "aggregated_race_demographics" do
  it "should return a hash with keys :AA, :AS, :WH, :HI, :UNK, :total, with zero values when no clients are passed in" do
    clients = ClientCollection.new([])
    clients.aggregated_race_demographics.should == {:AA => 0, :AS => 0, :WH => 0, :HI => 0, :UNK => 0, :total => 0}
  end

  it "should return a hash with keys :AA, :AS, :WH, :HI, :UNK, :total" do
    client1 = FactoryGirl.build(:client, :race => 'AA')
    client2 = FactoryGirl.build(:client, :race => 'AS')
    client3 = FactoryGirl.build(:client, :race => 'WH')
    client4 = FactoryGirl.build(:client, :race => 'HI')
    client5 = FactoryGirl.build(:client, :race => 'OT')
    clients = ClientCollection.new([client1, client2, client3, client4, client5])
    clients.aggregated_race_demographics.should == {:AA => 1, :AS => 1, :WH => 1, :HI => 1, :UNK => 1, :total => 5}
  end
end

describe "counts_by_age_group method" do
  context "when no clients are present" do
    before(:each) do
      collection = ClientCollection.new([])
      @counts = collection.counts_by_age_group
    end

    it "should return a hash with keys [:infants, :youth, :adult, :senior_adult, :elders]" do
      [:infants, :youths, :adults, :senior_adults, :elders, :children, :seniors].each do |k|
        @counts.should have_key(k)
      end
    end

    it "should return a hash with values representing the counts in the collection" do
      @counts[:infants].should       == 0
      @counts[:youths].should        == 0
      @counts[:children].should      == 0
      @counts[:adults].should        == 0
      @counts[:senior_adults].should == 0
      @counts[:elders].should        == 0
      @counts[:seniors].should       == 0
    end
  end

  context "when clients are present" do
    before(:each) do
      clients  = [FactoryGirl.build(:client, :infant,      :male)]
      clients  << FactoryGirl.build(:client, :infant,      :female)
      clients  << FactoryGirl.build(:client, :youth,       :male)
      clients  << FactoryGirl.build(:client, :youth,       :female)
      clients  << FactoryGirl.build(:client, :adult,       :male)
      clients  << FactoryGirl.build(:client, :adult,       :female)
      clients  << FactoryGirl.build(:client, :senior_adult,:male)
      clients  << FactoryGirl.build(:client, :senior_adult,:female)
      clients  << FactoryGirl.build(:client, :elder,       :male)
      clients  << FactoryGirl.build(:client, :elder,       :female)
      collection = ClientCollection.new(clients)
      @counts = collection.counts_by_age_group
    end

    it "should return a hash with keys [:infants, :youth, :adult, :senior_adult, :elders]" do
      [:infants, :youths, :adults, :senior_adults, :elders, :children, :seniors].each do |k|
        @counts.should have_key(k)
      end
    end

    it "should return a hash with values representing the counts in the collection" do
      @counts[:infants].should       == 2
      @counts[:youths].should        == 2
      @counts[:children].should      == 4
      @counts[:adults].should        == 2
      @counts[:senior_adults].should == 2
      @counts[:elders].should        == 2
      @counts[:seniors].should       == 4
    end
  end

  context "when one of the clients has a null birthdate" do
    before(:each) do
      clients  = [FactoryGirl.build(:client, :infant,      :male)]
      clients  << FactoryGirl.build(:client, :female, :birthdate => nil)
      collection = ClientCollection.new(clients)
      @counts = collection.counts_by_age_group
    end

    it "should return a hash with keys [:infants, :youth, :adult, :senior_adult, :elders]" do
      [:infants, :youths, :adults, :senior_adults, :elders, :children, :seniors, :unknowns].each do |k|
        @counts.should have_key(k)
      end
    end

    it "should return a hash with values representing the counts in the collection" do
      @counts[:infants].should       == 1
      @counts[:youths].should        == 0
      @counts[:children].should      == 1
      @counts[:adults].should        == 0
      @counts[:senior_adults].should == 0
      @counts[:elders].should        == 0
      @counts[:seniors].should       == 0
      @counts[:unknowns].should      == 1
    end
  end
end

describe 'counts_by_age_group_and_gender' do
  context 'when the household does not have any clients' do
    before(:each) do
      collection = ClientCollection.new([])
      @counts = collection.counts_by_age_group_and_gender
    end

    it "should count clients by age group" do
      @counts[:m][:infants].should       == 0
      @counts[:f][:infants].should       == 0
      @counts[:m][:youths].should        == 0
      @counts[:f][:youths].should        == 0
      @counts[:m][:adults].should        == 0
      @counts[:f][:adults].should        == 0
      @counts[:m][:senior_adults].should == 0
      @counts[:f][:senior_adults].should == 0
      @counts[:m][:elders].should        == 0
      @counts[:f][:elders].should        == 0
      @counts[:m][:unknowns].should      == 0
      @counts[:f][:unknowns].should      == 0
    end
  end

  context 'when the household has clients' do
    before(:each) do
      clients  = [FactoryGirl.build(:client, :infant,      :male)]
      clients  << FactoryGirl.build(:client, :infant,      :female)
      clients  << FactoryGirl.build(:client, :youth,       :male)
      clients  << FactoryGirl.build(:client, :youth,       :female)
      clients  << FactoryGirl.build(:client, :adult,       :male)
      clients  << FactoryGirl.build(:client, :adult,       :female)
      clients  << FactoryGirl.build(:client, :senior_adult,:male)
      clients  << FactoryGirl.build(:client, :senior_adult,:female)
      clients  << FactoryGirl.build(:client, :elder,       :male)
      clients  << FactoryGirl.build(:client, :elder,       :female)
      collection = ClientCollection.new(clients)
      @counts = collection.counts_by_age_group_and_gender
    end

    it "should count clients by age group and gender" do
      @counts[:m][:infants].should       == 1
      @counts[:f][:infants].should       == 1
      @counts[:m][:youths].should        == 1
      @counts[:f][:youths].should        == 1
      @counts[:m][:adults].should        == 1
      @counts[:f][:adults].should        == 1
      @counts[:m][:senior_adults].should == 1
      @counts[:f][:senior_adults].should == 1
      @counts[:m][:elders].should        == 1
      @counts[:f][:elders].should        == 1
      @counts[:m][:unknowns].should      == 0
      @counts[:f][:unknowns].should      == 0
    end
  end

  context 'when some clients have null birthdate' do
    before(:each) do
      clients  = [FactoryGirl.build(:client, :infant,      :male)]
      clients  << FactoryGirl.build(:client, :elder,       :female, :birthdate => nil)
      collection = ClientCollection.new(clients)
      @counts = collection.counts_by_age_group_and_gender
    end

    it "should count clients by age group" do
      @counts[:m][:infants].should       == 1
      @counts[:f][:unknowns].should      == 1
    end
  end
end

describe 'counts_by_race' do
  context "when the household does not have any clients" do
    before(:each) do
      @counts = ClientCollection.new([]).counts_by_race
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

  context "when clients are non-empty" do
    before(:each) do
      clients = [FactoryGirl.create(:client, :AA)]
      clients << FactoryGirl.create(:client, :AS)
      clients << FactoryGirl.create(:client, :HI)
      clients << FactoryGirl.create(:client, :WH)
      clients << FactoryGirl.create(:client, :OT)
      clients << FactoryGirl.create(:client, :race => nil)
      @counts = ClientCollection.new(clients).counts_by_race
    end

    it "should count clients by race" do
      @counts[:AA].should == 1
      @counts[:AS].should == 1
      @counts[:HI].should == 1
      @counts[:WH].should == 1
      @counts[:OT].should == 1
      @counts[:UNK].should == 1
      @counts[:total].should == 6
    end

  end
end

describe 'counts_by_race_and_gender' do
  context "when the household does not have any clients" do
    before(:each) do
      @counts = ClientCollection.new([]).counts_by_race_and_gender
    end

    it "should count clients by race" do
      @counts[:m][:AA].should == 0
      @counts[:m][:AS].should == 0
      @counts[:m][:HI].should == 0
      @counts[:m][:WH].should == 0
      @counts[:m][:UNK].should == 0
      @counts[:m][:total].should == 0
      @counts[:f][:AA].should == 0
      @counts[:f][:AS].should == 0
      @counts[:f][:HI].should == 0
      @counts[:f][:WH].should == 0
      @counts[:f][:UNK].should == 0
      @counts[:f][:total].should == 0
    end
  end

  context "when clients are non-empty" do
    before(:each) do
      clients = [FactoryGirl.create(:client, :male, :AA)]
      clients << FactoryGirl.create(:client, :male, :AS)
      clients << FactoryGirl.create(:client, :male, :HI)
      clients << FactoryGirl.create(:client, :male, :WH)
      clients << FactoryGirl.create(:client, :male, :OT)
      clients << FactoryGirl.create(:client, :male, :race => nil)
      clients << FactoryGirl.create(:client, :female, :AA)
      clients << FactoryGirl.create(:client, :female, :AS)
      clients << FactoryGirl.create(:client, :female, :HI)
      clients << FactoryGirl.create(:client, :female, :WH)
      clients << FactoryGirl.create(:client, :female, :OT)
      clients << FactoryGirl.create(:client, :female, :race => nil)
      @counts = ClientCollection.new(clients).counts_by_race_and_gender
    end

    it "should count clients by race" do
      @counts[:m][:AA].should == 1
      @counts[:m][:AS].should == 1
      @counts[:m][:HI].should == 1
      @counts[:m][:WH].should == 1
      @counts[:m][:OT].should == 1
      @counts[:m][:UNK].should == 1
      @counts[:m][:total].should == 6
      @counts[:f][:AA].should == 1
      @counts[:f][:AS].should == 1
      @counts[:f][:HI].should == 1
      @counts[:f][:WH].should == 1
      @counts[:f][:OT].should == 1
      @counts[:f][:UNK].should == 1
      @counts[:f][:total].should == 6
    end

  end
end
