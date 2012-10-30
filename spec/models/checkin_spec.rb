require 'spec_helper'

describe Checkin do
  context ".new method with client attribute" do
    context "client has no household" do
      let(:client){ FactoryGirl.create(:client) }
      it { expect{ Checkin.new(:client => client) }.to raise_error(Checkin::InvalidClientError) }
      it { expect{ Checkin.new(:client => Household.new) }.to raise_error(Checkin::InvalidClientError) }
    end

    context "client has associated household" do
      let(:client){ FactoryGirl.create(:client) }
      let(:household){ FactoryGirl.create(:household) }
      let(:checkin){ Checkin.new(:client => client) }
      before { household.clients << client }
      it { expect{ Checkin.new(:client => client )}.not_to raise_error }

      it 'should have an unpersisted household_checkin' do
        checkin.household_checkin.new_record?.should == true
      end

      it 'should associate the household_checkin with the household' do
        checkin.household_checkin.household_id.should == household.id
      end

      it 'should have an array of client_checkins' do
        checkin.client_checkins.should be_a(Array)
        checkin.client_checkins.each { |cc| cc.should be_a(ClientCheckin) }
      end

      it 'should have a household object' do
        checkin.household.should == household
      end
    end

    context "when there are multiple clients in the household" do
      describe "#primary_client_id" do
        let(:client){ FactoryGirl.create(:client) }
        let(:other_client){ FactoryGirl.create(:client) }
        let(:household){ FactoryGirl.create(:household) }
        let(:checkin){ Checkin.new(:client => client) }
        before { household.clients << [client, other_client] }

        it "should return the id of the client checking in on behalf of the household" do
          checkin.primary_client_id.should == client.id
        end
      end
    end
  end

  context '.new method with household_checkin attribute' do
    context 'household_checkin is not a HouseholdCheckin object' do
      let(:household_checkin){ "not a HouseholdCheckin object" }
      it{ expect{ Checkin.new(:household_checkin => household_checkin) }.to raise_error(Checkin::InvalidHouseholdCheckinError)}
    end

    context 'household_checkin is a valid HouseholdCheckin' do
      let(:household){ FactoryGirl.create(:household) }
      let(:client){ FactoryGirl.create(:client, :household_id => household) }
      let(:household_checkin){ HouseholdCheckin.create(:household => household) }
      let(:checkin){ Checkin.new(:household_checkin => household_checkin ) }
      it{ expect{ Checkin.new(:household_checkin => household_checkin) }.not_to raise_error}

      it 'should store the passed-in HouseholdCheckin in its household_checkin variable' do
        checkin.household_checkin.should == household_checkin
      end
    end
  end

  describe '.find_by_client_checkin_id' do
    let(:household){ FactoryGirl.create(:household) }
    let(:client){ FactoryGirl.create(:client, :household_id => household.id) }
    let(:household_checkin){ HouseholdCheckin.create(:household_id => household.id) }
    let(:client_checkin){ ClientCheckin.create(:client_id => client.id, :household_checkin_id => household_checkin.id) }
    before do
      @checkin = Checkin.find_by_client_checkin_id(client_checkin.id)
    end

    it "should have an existing HouseholdCheckin object" do
      @checkin.household_checkin.should == household_checkin
      @checkin.household_checkin.new_record?.should == false
    end

    it "should have existing ClientCheckin objects" do
      @checkin.client_checkins.should == [client_checkin]
    end
  end

  describe '#save method' do
    context 'when client_checkins and household_checkins already existed' do
      let(:household){ FactoryGirl.create(:household) }
      let(:client){ FactoryGirl.create(:client, :household_id => household.id) }
      let(:household_checkin){ HouseholdCheckin.create(:household_id => household.id) }
      let(:client_checkin){ ClientCheckin.create(:client_id => client.id, :household_checkin_id => household_checkin.id) }
      before do
        checkin = Checkin.find_by_client_checkin_id(client_checkin.id)
        checkin.save
      end

      it 'should save a client_checkin for the client' do
        ClientCheckin.count.should == 1
      end

      it 'should save a household_checkin for the clients household' do
        HouseholdCheckin.count.should == 1
      end
    end

    context 'when client_checkins and household_checkins did not previously exist' do
      let(:household){ FactoryGirl.create(:household) }
      let(:client){ FactoryGirl.create(:client, :household_id => household.id) }
      before do
        Checkin.create(client)
      end

      it 'should save a client_checkin for the client' do
        ClientCheckin.count.should == 1
      end

      it 'should associate its client_checkin with its household_checkin' do
        ClientCheckin.first.household_checkin_id.should == HouseholdCheckin.first.id
      end

      it 'should save a household_checkin for the clients household' do
        HouseholdCheckin.count.should == 1
      end
    end
  end
end
