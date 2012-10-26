require 'spec_helper'

describe CheckinsController do
  before do
    controller.stub('logged_in?').and_return(true)
    controller.stub('check_permissions').and_return(true)
  end

  describe '#new' do
    subject { response }
    before do
      get :new
    end

    it { should render_template('client_finder') }
  end

  describe '#create' do
    subject { response }

    context 'when the client has no household' do
      before do
        client = FactoryGirl.create(:client)
        post :create, {:client_id => client.id}
      end

      it { should render_template('quickcheck_fail') }
    end

    context 'when the client belongs to a household' do
      let(:household){ FactoryGirl.create(:household_with_current_docs) }
      let(:client){ FactoryGirl.create(:client_with_current_id, :household => household) }
      let(:other_client){ FactoryGirl.create(:client_with_current_id, :household => household) }

      before do
        household.clients = [client, other_client]
        post :create, {:client_id => client.id}
      end

      describe "client checkins created" do
        let(:checkins){ ClientCheckin.find_all_by_client_id(client.id) }
        subject { checkins.first }

        it "should create a single client checkin" do
          checkins.length.should == 1
        end

        its(:household_checkin_id) { should == HouseholdCheckin.find_all_by_household_id(household.id).last.id }
        its(:primary) { should == true }
        its(:id_warn) { should == false }
      end

      describe "household checkin created" do
        let(:checkins){ HouseholdCheckin.find_all_by_household_id(household.id) }
        subject { checkins.first }

        it "should create a single checkin for the household" do
          checkins.length.should == 1
        end

        its(:res_warn) { should == false }
        its(:inc_warn) { should == false }
        its(:gov_warn) { should == false }
        its(:household_id) { should == household.id }
      end

      describe "client checkins for all clients of the household" do
        let(:checkins){ ClientCheckin.find_all_by_household_checkin_id(HouseholdCheckin.find_by_household_id(household.id).id) }
        subject { checkins }

        its(:length) { should == 2 }

        it "should include a single primary client checkin" do
          checkins.select(&:primary).length.should == 1
        end

        it "should include a single primary checkin that is not primary" do
          checkins.select{|c| !c.primary}.length.should == 1
        end
      end
    end
  end

  describe '#edit' do

    context 'when the client household has errors' do
      before do
        household = FactoryGirl.create(:household_with_expired_docs)
        client = FactoryGirl.create(:client, :household => household)
        checkin = Checkin.create(client)
        get :edit, {:client_id => client.id, :id => checkin.id}
      end

      it { should render_template('quickcheck_with_errors') }
    end

    context 'when the client household has no errors' do
      before do
        household = FactoryGirl.create(:household_with_current_docs)
        client = FactoryGirl.create(:client_with_current_id, :household => household)
        checkin = Checkin.create(client)
        get :edit, {:client_id => client.id, :id => checkin.id}
      end

      it { should render_template('quickcheck_without_errors') }
    end
  end

  describe '#update' do
    let(:household){ FactoryGirl.create(:household) }
    let(:client){ FactoryGirl.create(:client, :household => household) }
    let(:another_client){ FactoryGirl.create(:client, :household => household) }
    let(:existing_client_doc){ FactoryGirl.create(:id_qualdoc, :client => client, :confirm => false, :warnings => 0) }
    let(:existing_res_doc){ FactoryGirl.create(:res_qualdoc, :household => household, :confirm => false, :warnings => 0) }
    let(:checkin){ Checkin.create(client)}

    context 'when client documents params have null-string id attributes' do
      before do
        params = {:client_id => client.id,
                  :id => checkin.id,
                  :qualification_documents => {0 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => 'true'},
                                               1 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => another_client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => 'true'},
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

      it 'should update the client checkin' do
        client_checkin = ClientCheckin.find_all_by_client_id(client.id)
        client_checkin.length.should == 1
        client_checkin.first.id_warn.should == true
      end

      it 'should not create a new household checkin' do
        HouseholdCheckin.find_all_by_household_id(household.id).length.should == 1
      end
    end

    context 'when client documents params have no id attributes' do
      before do
        params = {:client_id => client.id,
                  :id => checkin.id,
                  :qualification_documents => {0 => {:doctype => 'id',
                                                     :association_id => client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => 'true'},
                                               1 => {:doctype => 'id',
                                                     :association_id => another_client.id,
                                                     :confirm => '1',
                                                     :warnings => 1,
                                                     :warned => 'true'},
                                               2 => {:doctype => 'res',
                                                     :association_id => household.id}}}
        put :update, params
      end

      it 'should create new client documents' do
        id_qualdocs = IdQualdoc.find_all_by_association_id(client.id)
        id_qualdocs.length.should == 1
        id_qualdocs.first.warnings.should == 1
        id_qualdocs.first.confirm.should == true
      end
    end

    context 'when client document params have id attributes' do
      before do
        params = {:client_id => client.id,
                  :id => checkin.id,
                  :qualification_documents => {0 => {:id => existing_client_doc.id,
                                                     :confirm => '1',
                                                     :date => 4.weeks.ago,
                                                     :doctype => 'id',
                                                     :association_id => client.id,
                                                     :warned => 'true'},
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

      it 'should not create a new client checkin' do
        client_checkin = ClientCheckin.find_all_by_client_id(client.id)
        client_checkin.length.should == 1
        client_checkin.first.id_warn.should == true
      end

      it 'should not create a new household checkin' do
        HouseholdCheckin.find_all_by_household_id(household.id).length.should == 1
      end
    end

    context 'when household documents params are retrieved without id attributes' do
      before do
        params = {:client_id => client.id,
                  :id => checkin.id,
                  :qualification_documents => {0 => {:id => 'null',
                                                     :doctype => 'id',
                                                     :association_id => client.id},
                                               1 => {:id => 'null',
                                                     :doctype => 'res',
                                                     :association_id => household.id,
                                                     :warned => 'true'}}}
        put :update, params
      end

      it 'should create new household documents' do
        ResQualdoc.find_all_by_association_id(household.id).length.should == 1
      end

      it 'should not create a new client checkin' do
        ClientCheckin.find_all_by_client_id(client.id).length.should == 1
      end

      it 'should not create a new household checkin' do
        household_checkin = HouseholdCheckin.find_all_by_household_id(household.id)
        household_checkin.length.should == 1
        household_checkin.first.res_warn.should == true
      end
    end

    context 'when household document params are retrieved with id attributes' do
      before do
        params = {:client_id => client.id,
                  :id => checkin.id,
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

      it 'should not create a new household checkin' do
        household_checkins = HouseholdCheckin.find_all_by_household_id(household.id)
        household_checkins.length.should == 1
        household_checkin = household_checkins.first
        household_checkin.res_warn.should == false
      end

      it 'should not create a new client checkin' do
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
