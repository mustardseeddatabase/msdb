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

describe 'days_of_distribution method' do
  before(:each) do
    @household = FactoryGirl.create(:household)
    @distribution1 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,1), :household_id => @household.id)
    @distribution2 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,6,8), :household_id => @household.id)
    @distribution3 = FactoryGirl.create(:distribution, :created_at => Date.new(2012,7,1), :household_id => @household.id)
  end

  it 'should return 2 days when the passed-in date is 2012,6,20' do
    collection = DistributionCollection.new(Date.new(2012,6,20))
    collection.days_of_distribution.should == 2
  end

  it 'should return 1 days when the passed-in date is 2012,7,20' do
    collection = DistributionCollection.new(Date.new(2012,7,20))
    collection.days_of_distribution.should == 1
  end

  it 'should return 0 days when the passed-in date is 2012,5,20' do
    collection = DistributionCollection.new(Date.new(2012,5,20))
    collection.days_of_distribution.should == 0
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
