require 'spec_helper'

describe "class method with_no_donations" do
  context "when the donor has no donations" do
    it "the returned array should include the donor object" do
      donor = FactoryGirl.create(:donor)
      Donor.with_no_donations.should == [donor]
    end
  end

  context "when the donor has donations" do
    it "the returned array should not include the donor object" do
      donor = FactoryGirl.create(:donor)
      donation = FactoryGirl.create(:donation, :donor_id => donor.id)
      Donor.with_no_donations.should == []
    end
  end
end
