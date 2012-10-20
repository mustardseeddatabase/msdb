require 'spec_helper'

describe ClientsController do
  before do
    controller.stub('logged_in?').and_return(true)
    controller.stub('check_permissions').and_return(true)
  end

  describe '#update' do
    context 'when client is head of household' do
      let(:household){ FactoryGirl.create(:household_with_current_docs) }
      let(:client){ FactoryGirl.create(:client_with_current_id, :household => household) }
      let(:other_client){ FactoryGirl.create(:client_with_current_id, :headOfHousehold => true, :household => household) }

      before do
        household.clients = [client, other_client]
        put :update, {:id => client.id, :client => {:headOfHousehold => true }}
      end

      it "assigns client as head of household" do
        client.reload
        client.headOfHousehold.should == true
      end

      it "de-assigns other client as head of household" do
        other_client.reload
        other_client.headOfHousehold.should == false
      end
    end # context

    context 'when client is assigned as head of household, but doesnt have a household' do
      let(:client){ FactoryGirl.create(:client_with_current_id) }

      before do
        put :update, {:id => client.id, :client => {:headOfHousehold => true }}
      end

      it "assigns client as head of household" do
        client.reload
        client.headOfHousehold.should == true
      end
    end # context
  end # describe #update
end # describe Controller
