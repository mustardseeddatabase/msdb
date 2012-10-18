require 'ruby-debug'
require 'spec_helper'

describe CheckinsController do
  describe '#update' do
    let(:household){ FactoryGirl.create(:household) }
    let(:client){ FactoryGirl.create(:client, :household => household) }
    let(:another_client){ FactoryGirl.create(:client, :household => household) }
    let(:existing_client_doc){ FactoryGirl.create(:id_qualdoc, :client => client, :confirm => false, :warnings => 0) }
    let(:existing_res_doc){ FactoryGirl.create(:res_qualdoc, :household => household, :confirm => false, :warnings => 0) }

    before do
      controller.stub('logged_in?').and_return(true)
      controller.stub('check_permissions').and_return(true)
    end

    context 'when client documents params are do not have id attributes' do
      before do
        params = {:client_id => client.id,
                  :qualification_documents => {0 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => '1'},
                                               1 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => another_client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => '1'},
                                               2 => {:id => 'null',
                                                     :doctype => 'res',
                                                     :association_id => household.id}}}
        put :update, params
      end

      it 'should create new client documents' do
        id_qualdocs = IdQualdoc.find_all_by_association_id(client.id)
        id_qualdocs.length.should == 1
        id_qualdocs.first.warnings.should == 1
        id_qualdocs.first.confirm.should == true
      end

      it 'should create a new client checkin' do
        client_checkin = ClientCheckin.find_all_by_client_id(client.id)
        client_checkin.length.should == 1
        client_checkin.first.id_warn.should == true
      end

      it 'should create a new household checkin' do
        HouseholdCheckin.find_all_by_household_id(household.id).length.should == 1
      end
    end

    context 'when client document params have id attributes' do
      before do
        params = {:client_id => client.id,
                  :qualification_documents => {0 => {:id => existing_client_doc.id,
                                                     :confirm => '1',
                                                     :date => 4.weeks.ago,
                                                     :doctype => 'id',
                                                     :association_id => client.id,
                                                     :warned => '1'},
                                               1 => {:id => 'null',
                                                     :doctype => 'res',
                                                     :association_id => household.id}}}
        put :update, params
      end

      it 'should update existing client documents' do
        existing_client_doc.reload
        existing_client_doc.confirm.should == true
        existing_client_doc.date.should == 4.weeks.ago.to_date
      end

      it 'should create a new client checkin' do
        client_checkin = ClientCheckin.find_all_by_client_id(client.id)
        client_checkin.length.should == 1
        client_checkin.first.id_warn.should == true
      end

      it 'should create a new household checkin' do
        HouseholdCheckin.find_all_by_household_id(household.id).length.should == 1
      end
    end

    context 'when household documents params are retrieved without id attributes' do
      before do
        params = {:client_id => client.id,
                  :qualification_documents => {0 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => client.id},
                                               1 => {:id => 'null',
                                                     :doctype => 'res',
                                                     :association_id => household.id,
                                                     :warned => '1'}}}
        put :update, params
      end

      it 'should create new household documents' do
        ResQualdoc.find_all_by_association_id(household.id).length.should == 1
      end

      it 'should create a new client checkin' do
        ClientCheckin.find_all_by_client_id(client.id).length.should == 1
      end

      it 'should create a new household checkin' do
        household_checkin = HouseholdCheckin.find_all_by_household_id(household.id)
        household_checkin.length.should == 1
        household_checkin.first.res_warn.should == true
      end
    end

    context 'when household document params are retrieved with id attributes' do
      before do
        params = {:client_id => client.id,
                  :qualification_documents => {0 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => client.id,
                                                     :warned => '0'},
                                               1 => {:id => existing_res_doc.id,
                                                     :confirm => '1',
                                                     :date => 4.weeks.ago,
                                                     :doctype => 'res',
                                                     :association_id => household.id,
                                                     :warned => '0'}}}
        put :update, params
      end

      it 'should update existing household documents' do
        existing_res_doc.reload
        existing_res_doc.confirm.should == true
        existing_res_doc.date.should == 4.weeks.ago.to_date
      end

      it 'should create a new household checkin' do
        household_checkins = HouseholdCheckin.find_all_by_household_id(household.id)
        household_checkins.length.should == 1
        household_checkin = household_checkins.first
        household_checkin.res_warn.should == false
      end

      it 'should create a new client checkin' do
        client_checkins = ClientCheckin.find_all_by_client_id(client.id)
        client_checkins.length.should == 1
        client_checkin = client_checkins.first
        client_checkin.id_warn.should == false
        household_checkin = HouseholdCheckin.find_by_household_id(client.household.id)
        client_checkin.household_checkin_id.should == household_checkin.id
      end
    end
  end
end
