require 'spec_helper'

describe 'in_month scope' do
  before(:each) do
    @distribution1 = Distribution.create(:created_at => Date.new(2012,5,1))
    @distribution2 = Distribution.create(:created_at => Date.new(2012,6,1))
    @distribution3 = Distribution.create(:created_at => Date.new(2012,7,1))
  end

  it 'should return distributions from the passed-in month' do
    Distribution.in_month(2012,6).should == [@distribution2]
  end
end

describe 'new?' do
  before(:each) do
    @household = FactoryGirl.create(:household)
    @distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,5,1), :household_id => @household.id)
    @distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => @household.id)
    @distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => @household.id)
  end

  it 'should return true for the first distribution of a household' do
    @distribution1.new?.should == true
  end

  it 'should return false for distributions other than the first' do
    @distribution2.new?.should == false
    @distribution3.new?.should == false
  end
end

describe 'days_of_distribution class method' do
  before(:each) do
    @household = FactoryGirl.create(:household)
    @distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => @household.id)
    @distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,8), :household_id => @household.id)
    @distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => @household.id)
  end

  it 'should return 2 days when the passed-in date is 2012,6,20' do
    collection = DistributionCollection.new(Date.new(2012,6,20))
    collection.days_of_distribution.count.should == 2
  end

  it 'should return 1 days when the passed-in date is 2012,7,20' do
    collection = DistributionCollection.new(Date.new(2012,7,20))
    collection.days_of_distribution.count.should == 1
  end

  it 'should return 0 days when the passed-in date is 2012,5,20' do
    collection = DistributionCollection.new(Date.new(2012,5,20))
    collection.days_of_distribution.count.should == 0
  end
end

describe 'unique_households class method' do
  before(:each) do
    household = FactoryGirl.create(:household)
    distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => household.id)
    distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => household.id)
    household = FactoryGirl.create(:household)
    distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,8), :household_id => household.id)
    household = FactoryGirl.create(:household)
    distribution4 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => household.id)
  end

  it 'should return 2 when the passed in date is 2012,6,20' do
    collection = DistributionCollection.new(Date.new(2012,6,20))
    collection.unique_households.count.should == 2
  end

  it 'should return 1 when the passed in date is 2012,7,20' do
    collection = DistributionCollection.new(Date.new(2012,7,20))
    collection.unique_households.count.should == 1
  end

  it 'should return 0 when the passed in date is 2012,5,20' do
    collection = DistributionCollection.new(Date.new(2012,5,20))
    collection.unique_households.count.should == 0
  end
end

describe 'unique_residents class method' do
  before(:all) do
    Client.delete_all
    client = FactoryGirl.create_list(:client, 5)
    household = FactoryGirl.create(:household)
    household.client_ids = Client.all.map(&:id)[0..2]
    distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => household.id)
    distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => household.id)
    household = FactoryGirl.create(:household)
    household.client_ids = Client.all.map(&:id)[2..-1]
    distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,8), :household_id => household.id)
    household = FactoryGirl.create(:household)
    household.client_ids = []
    distribution4 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => household.id)
  end

  it 'should return 5 when the passed in date is 2012,6,20' do
    collection = DistributionCollection.new(Date.new(2012,6,20))
    collection.unique_residents.count.should == 5
  end

  it 'should return 0 when the passed in date is 2012,7,20' do
    collection = DistributionCollection.new(Date.new(2012,7,20))
    collection.unique_residents.count.should == 0
  end

  it 'should return 0 when the passed in date is 2012,5,20' do
    collection = DistributionCollection.new(Date.new(2012,5,20))
    collection.unique_residents.count.should == 0
  end
end

describe 'new_households class method' do
  before(:all) do
    Household.delete_all
    Distribution.delete_all
    household = FactoryGirl.create(:household)
    distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,5,1), :household_id => household.id)
    distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => household.id)
    household = FactoryGirl.create(:household)
    distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,8), :household_id => household.id)
    household = FactoryGirl.create(:household)
    distribution4 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => household.id)
  end

  it "should return 1 when the passed-in date is 2012,6,20" do
    collection = DistributionCollection.new(Date.new(2012,6,20))
    collection.new_households.count.should == 1
  end

  it "should return 1 when the passed-in date is 2012,5,20" do
    collection = DistributionCollection.new(Date.new(2012,5,20))
    collection.new_households.count.should == 1
  end
end

describe 'lbs_of_food_distributed class method' do
  before(:all) do
    Distribution.delete_all
    DistributionItem.delete_all
    distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,5,1))
    item1 = FactoryGirl.create(:item, :weight_oz => 16)
    distribution_item1 = FactoryGirl.create(:distribution_item, :quantity => 5, :item_id => item1.id, :transaction_id => distribution1.id)
    item2 = FactoryGirl.create(:item, :weight_oz => 6)
    distribution_item2 = FactoryGirl.create(:distribution_item, :quantity => 5, :item_id => item2.id, :transaction_id => distribution1.id)
  end

  it "should total the number of pounds in all distributions for the month" do
    collection = DistributionCollection.new(Date.new(2012,5,30))
    collection.lbs_of_food_distributed.should == (110.to_f/16).round(2)
  end
end
