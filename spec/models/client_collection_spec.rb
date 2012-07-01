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

describe "counts_by_gender method" do
  context "when no clients are in the collection" do
    before(:each) do
      collection = ClientCollection.new([])
      @counts = collection.counts_by_gender
    end

    it "should return a hash with zero values" do
      @counts[:m].should == 0
      @counts[:f].should == 0
      @counts[:u].should == 0
      @counts[:t].should == 0
    end
  end

  context "when clients are in the collection" do
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
      @counts = collection.counts_by_gender
    end

    it "should return a hash with values representing the counts in the collection" do
      @counts[:m].should == 5
      @counts[:f].should == 5
      @counts[:u].should == 0
      @counts[:t].should == 10
    end
  end

end

describe 'counts_by_age_group_and_gender' do
  context 'when the collection does not have any clients' do
    before(:each) do
      collection = ClientCollection.new([])
      @counts = collection.counts_by_age_group_and_gender
    end

    it "should count clients by age group" do
      @counts[:infants][:m].should       == 0
      @counts[:infants][:f].should       == 0
      @counts[:infants][:u].should       == 0
      @counts[:youths][:m].should        == 0
      @counts[:youths][:f].should        == 0
      @counts[:youths][:u].should        == 0
      @counts[:adults][:m].should        == 0
      @counts[:adults][:f].should        == 0
      @counts[:adults][:u].should        == 0
      @counts[:senior_adults][:m].should == 0
      @counts[:senior_adults][:f].should == 0
      @counts[:senior_adults][:u].should == 0
      @counts[:elders][:m].should        == 0
      @counts[:elders][:f].should        == 0
      @counts[:elders][:u].should        == 0
      @counts[:unknowns][:m].should      == 0
      @counts[:unknowns][:f].should      == 0
      @counts[:unknowns][:u].should      == 0
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
      @counts[:infants][:m].should       == 1
      @counts[:infants][:f].should       == 1
      @counts[:infants][:u].should       == 0
      @counts[:youths][:m].should        == 1
      @counts[:youths][:f].should        == 1
      @counts[:youths][:u].should        == 0
      @counts[:adults][:m].should        == 1
      @counts[:adults][:f].should        == 1
      @counts[:adults][:u].should        == 0
      @counts[:senior_adults][:m].should == 1
      @counts[:senior_adults][:f].should == 1
      @counts[:senior_adults][:u].should == 0
      @counts[:elders][:m].should        == 1
      @counts[:elders][:f].should        == 1
      @counts[:elders][:u].should        == 0
      @counts[:unknowns][:m].should      == 0
      @counts[:unknowns][:f].should      == 0
      @counts[:unknowns][:u].should      == 0
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
      @counts[:infants][:m].should       == 1
      @counts[:unknowns][:f].should      == 1
      @counts[:unknowns][:u].should      == 0
    end
  end
end

describe 'grouped_by_race' do
  context "when there are no clients in the collection" do
    it "should have keys ['African American', 'Asian', 'Hispanic', 'White', 'Other', 'Unknown', 'Total'] and all values zero" do
      ['African American', 'Asian', 'Hispanic', 'White', 'Other', 'Unknown', 'Total'].each do |key|
        ClientCollection.new([]).grouped_by_race.keys.should include key
      end
    end
  end
end

describe 'counts_by_race_and_gender' do
  context "when the household does not have any clients" do
    before(:each) do
      @counts = ClientCollection.new([]).counts_by_race_and_gender
    end

    it "should count clients by race" do
      @counts['African American'][:m].should == 0
      @counts['Asian'][:m].should == 0
      @counts['Hispanic'][:m].should == 0
      @counts['White'][:m].should == 0
      @counts['Unknown'][:m].should == 0
      @counts['Total'][:m].should == 0
      @counts['African American'][:f].should == 0
      @counts['Asian'][:f].should == 0
      @counts['Hispanic'][:f].should == 0
      @counts['White'][:f].should == 0
      @counts['Unknown'][:f].should == 0
      @counts['Total'][:f].should == 0
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
      @counts['African American'][:m].should == 1
      @counts['Asian'][:m].should == 1
      @counts['Hispanic'][:m].should == 1
      @counts['White'][:m].should == 1
      @counts['Other'][:m].should == 1
      @counts['Unknown'][:m].should == 1
      @counts['Total'][:m].should == 6
      @counts['African American'][:f].should == 1
      @counts['Asian'][:f].should == 1
      @counts['Hispanic'][:f].should == 1
      @counts['White'][:f].should == 1
      @counts['Other'][:f].should == 1
      @counts['Unknown'][:f].should == 1
      @counts['Total'][:f].should == 6
    end

  end
end
