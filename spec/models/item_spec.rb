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

describe "canonical scope" do
  it "returns only items with canonical set to true" do
    canonical_item = FactoryGirl.create(:item, :canonical => true)
    non_canonical_item = FactoryGirl.create(:item, :canonical => false)
    Item.canonical.first.should == canonical_item
  end
end

describe "with_attributes class method" do
  before(:all) do
    @item1 = FactoryGirl.create(:item)
    @item2 = FactoryGirl.create(:item, :sku => 123)
    @item3 = FactoryGirl.create(:item, :upc => 12341234)
  end

  it "returns a single model with matching id, when id attribute is passed-in" do
    found_item = Item.find_with_attributes(:id => @item1.id, :sku => 123, :upc => @item3.upc)
    found_item.should == @item1
  end

  it "returns a single model with matching upc, when id attribute is not present and upc is passed-in" do
    found_item = Item.find_with_attributes(:id => nil, :sku => nil, :upc => @item3.upc)
    found_item.should == @item3
  end

  it "returns a single model with matching sku, when id and upc attributes are nil and sku is passed-in" do
    found_item = Item.find_with_attributes(:id => nil, :sku => @item2.sku, :upc => nil)
    found_item.should == @item2
  end
end
