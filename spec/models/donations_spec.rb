require 'spec_helper'

describe "most_recent_five scope" do
  before(:each) do
    w = 1
    6.times do
      donor = FactoryGirl.create(:donor)
      FactoryGirl.create(:donation, :created_at => w.weeks.ago, :donor_id => donor.id)
      w += 1
    end
  end

  it "should return five donation objects" do
    donations = Donation.most_recent_five
    donations.length.should == 5
    donations.each{|d| d.should be_kind_of(Donation)}
  end

  it "should return the most recent five objects" do
    most_recent_older_donation_date = 6.weeks.ago
    Donation.most_recent_five.each do |d|
      d.created_at.should > most_recent_older_donation_date
    end
  end
end

describe "nested attributes behaviour" do
  before (:all) do
    Donation.delete_all
    DonatedItem.delete_all
    Item.delete_all
    item_attributes = { :description => 'tasty grits', 
                        :upc => 55667788, 
                        :weight_oz => 5, 
                        :count => 1, 
                        :category_id => 1, 
                        :limit_category_id => 1}
    donated_item_attributes = {:quantity => 5, :item_attributes => item_attributes}
    @donation = Donation.create(:donated_items_attributes => [donated_item_attributes])
  end

  it "there should be one Donation" do
    Donation.count.should == 1
  end

  it "there should be one DonatedItem" do
    DonatedItem.count.should == 1
    Donation.first.donated_items.count.should == 1
  end

  it "there should be one Item" do
    Item.count.should == 1
    Donation.first.donated_items.first.item.should be_true
  end

  it "should update nested donation_items" do
    item_attributes = Item.first.attributes
    item_attributes['description'] = 'good grub'
    donated_item_attributes = DonatedItem.first.attributes
    donated_item_attributes['item_attributes'] = item_attributes
    @donation.update_attributes(:donated_items_attributes => [donated_item_attributes])
    Donation.count.should == 1
    DonatedItem.count.should == 1
    Donation.first.donated_items.count.should == 1
    Item.count.should == 1
    Donation.first.donated_items.first.item.should be_true
  end
end

describe "nested attributes behaviour" do
  before (:all) do
    Distribution.delete_all
    DistributionItem.delete_all
    Item.delete_all
    item_attributes = { :description => 'tasty grits', 
                        :upc => 55667788, 
                        :weight_oz => 5, 
                        :count => 1, 
                        :category_id => 1, 
                        :limit_category_id => 1}
    item = Item.create(item_attributes)
    distribution_item_attributes = {:quantity => 5, :item_attributes => item.attributes}
    distribution_items_attributes = {:distribution_items_attributes => [distribution_item_attributes]}
    @distribution = Distribution.create(distribution_items_attributes)
  end

  it "there should be one Distribution" do
    Distribution.count.should == 1
  end

  it "there should be one DistributionItem" do
    DistributionItem.count.should == 1
    Distribution.first.distribution_items.count.should == 1
  end

  it "there should be one Item" do
    Item.count.should == 1
    Distribution.first.distribution_items.first.item.should be_true
  end

  it "should update nested donation_items" do
    item_attributes = Item.first.attributes
    item_attributes['description'] = 'good grub'
    distribution_item_attributes = DistributionItem.first.attributes
    distribution_item_attributes['item_attributes'] = item_attributes
    distribution_item_attributes.delete("item_id")
    distribution_items_attributes = {:distribution_items_attributes => [distribution_item_attributes]}
    @distribution.update_attributes(distribution_items_attributes)
    Distribution.count.should == 1
    DistributionItem.count.should == 1
    Distribution.first.distribution_items.count.should == 1
    Item.count.should == 1
    Distribution.first.distribution_items.first.item.should be_true
  end
end
