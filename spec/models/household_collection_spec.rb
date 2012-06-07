require 'spec_helper'

describe "aggregated_age_group_demographics class method" do
  it "should sum the values of the demographics of the households in the collection" do
    household1 = flexmock(Household.new, :counts_by_age_group => {:children=>0, :adults=>0, :seniors=>0}, :count_by_homeless => {:homeless=>0})
    household2 = flexmock(Household.new, :counts_by_age_group => {:children=>1, :adults=>2, :seniors=>3}, :count_by_homeless => {:homeless=>9})
    household3 = flexmock(Household.new, :counts_by_age_group => {:children=>2, :adults=>3, :seniors=>4}, :count_by_homeless => {:homeless=>0})
    households = HouseholdCollection.new([household1, household2, household3])
    households.aggregated_age_group_demographics.should == {:household => 3, :children=>3, :adults=>5, :seniors=>7, :homeless=>9}
  end
end

describe "report_demographics class method" do
  context "when there are no households in the collection" do
    it "should return a hash with keys :new and :continued" do
      collection = HouseholdCollection.new([])
      demographic = collection.report_demographics(Date.today)
      demographic.should be_kind_of(Hash)
      demographic.keys.should include(:new)
      demographic.keys.should include(:continued)
      demographic.keys.should include(:male)
      demographic.keys.should include(:female)
      demographic.keys.should include(:total)
    end

    it "should return a hash of hashes with keys :household :children, :adults, :seniors, :AA, :AS, :WH, :HI, :UNK, :homeless" do
      collection = HouseholdCollection.new([])
      demographic = collection.report_demographics(Date.today)
      demographic[:new][:children].should == 0
      demographic[:new][:household].should == 0
      demographic[:new][:adults].should == 0
      demographic[:new][:seniors].should == 0
      demographic[:new][:homeless].should == 0
      demographic[:male][:AA].should == 0
      demographic[:male][:AS].should == 0
      demographic[:male][:WH].should == 0
      demographic[:male][:HI].should == 0
      demographic[:male][:UNK].should == 0
      demographic[:male][:total].should == 0
      demographic[:continued][:household].should == 0
      demographic[:continued][:children].should == 0
      demographic[:continued][:adults].should == 0
      demographic[:continued][:seniors].should == 0
      demographic[:continued][:homeless].should == 0
      demographic[:female][:AA].should == 0
      demographic[:female][:AS].should == 0
      demographic[:female][:WH].should == 0
      demographic[:female][:HI].should == 0
      demographic[:female][:UNK].should == 0
      demographic[:female][:total].should == 0
      demographic[:total][:household].should == 0
      demographic[:total][:children].should == 0
      demographic[:total][:adults].should == 0
      demographic[:total][:seniors].should == 0
      demographic[:total][:AA].should == 0
      demographic[:total][:AS].should == 0
      demographic[:total][:WH].should == 0
      demographic[:total][:HI].should == 0
      demographic[:total][:UNK].should == 0
      demographic[:total][:homeless].should == 0
      demographic[:total][:total].should == 0
    end
  end

  context "when there are households in the collection" do
    before(:each) do
      household = FactoryGirl.create(:household)
      dist = FactoryGirl.create(:distribution, :created_at => Date.today, :household_id => household.id)
      household.distributions << dist
      household.clients << FactoryGirl.create(:client, :birthdate => 10.years.ago, :race => 'AA', :gender => "F")
      household.clients << FactoryGirl.create(:client, :birthdate => 80.years.ago, :race => nil, :gender => "M")
      @household_collection = HouseholdCollection.new([household])
    end

    it "should return a hash with keys :new and :continued" do
      demographic = @household_collection.report_demographics(1.month.ago)
      demographic.should be_kind_of(Hash)
      demographic.keys.should include(:new)
      demographic.keys.should include(:continued)
      demographic.keys.should include(:total)
    end

    it "should return a hash of hashes with keys :children, :adults, :seniors, :AA, :AS, :WH, :HI, :UNK, :homeless" do
      demographic = @household_collection.report_demographics(Date.today)
      demographic[:new][:household].should == 1
      demographic[:new][:children].should == 1
      demographic[:new][:adults].should == 0
      demographic[:new][:seniors].should == 1
      demographic[:new][:homeless].should == 0

      demographic[:male][:AA].should == 0
      demographic[:male][:AS].should == 0
      demographic[:male][:WH].should == 0
      demographic[:male][:HI].should == 0
      demographic[:male][:UNK].should == 1
      demographic[:male][:total].should == 1

      demographic[:continued][:household].should == 0
      demographic[:continued][:children].should == 0
      demographic[:continued][:adults].should == 0
      demographic[:continued][:seniors].should == 0
      demographic[:continued][:homeless].should == 0

      demographic[:female][:AA].should == 1
      demographic[:female][:AS].should == 0
      demographic[:female][:WH].should == 0
      demographic[:female][:HI].should == 0
      demographic[:female][:UNK].should == 0
      demographic[:female][:total].should == 1

      demographic[:total][:household].should == 1
      demographic[:total][:children].should == 1
      demographic[:total][:adults].should == 0
      demographic[:total][:seniors].should == 1
      demographic[:total][:homeless].should == 0
      demographic[:total][:AA].should == 1
      demographic[:total][:AS].should == 0
      demographic[:total][:WH].should == 0
      demographic[:total][:HI].should == 0
      demographic[:total][:UNK].should == 1
      demographic[:total][:total].should == 2
    end
  end
end
