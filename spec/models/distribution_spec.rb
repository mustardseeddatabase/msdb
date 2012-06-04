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
