require 'spec_helper'

describe "#document_type method" do
  it "should return 'id' for an IdQualdoc" do
    qd = IdQualdoc.new
    qd.document_type.should == "id"
  end

  it "should return 'res' for an ResQualdoc" do
    qd = ResQualdoc.new
    qd.document_type.should == "res"
  end

  it "should return 'gov' for an GovQualdoc" do
    qd = GovQualdoc.new
    qd.document_type.should == "gov"
  end

  it "should return 'inc' for an IncQualdoc" do
    qd = IncQualdoc.new
    qd.document_type.should == "inc"
  end
end

describe "#belongs_to? method" do
  it "should return true if it's an IdQualdoc for the passed-in client" do
    client = Factory.create(:client_with_current_id)
    client.id_qualdoc.belongs_to?(client).should == true
    another_client = Factory.create(:client_with_current_id)
    client.id_qualdoc.belongs_to?(another_client).should == false
  end

  it "should return true if it's an ResQualdoc for the passed-in client's household" do
    household = Factory.create(:household_with_docs)
    client = Factory.build(:client_with_current_id, :household => household)
    household.clients << client
    household.res_qualdoc.belongs_to?(client).should == true
  end

  it "should return true if it's an GovQualdoc for the passed-in client's household" do
    household = Factory.create(:household_with_docs)
    client = Factory.build(:client_with_current_id, :household => household)
    household.clients << client
    household.gov_qualdoc.belongs_to?(client).should == true
  end

  it "should return true if it's an IncQualdoc for the passed-in client's household" do
    household = Factory.create(:household_with_docs)
    client = Factory.build(:client_with_current_id, :household => household)
    household.clients << client
    household.inc_qualdoc.belongs_to?(client).should == true
  end

  it "should return false if it's an IdQualdoc and does not belong to the passed-in client" do
    client = Factory.build(:client_with_current_id)
  end
end
