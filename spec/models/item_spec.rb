require 'spec_helper'

describe "excluding scope" do
  before(:all) do
    FactoryGirl.create_list(:item,4)
    exclude_list = Item.all.map(&:id)[0,2]
    @remaining = Item.all.map(&:id) - exclude_list
    @items = Item.excluding(exclude_list)
  end

  it "should return items with ids not in list" do
    @items.map(&:id).should == @remaining
  end
end
