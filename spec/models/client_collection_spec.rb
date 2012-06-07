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
