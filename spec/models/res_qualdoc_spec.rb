require 'spec_helper'

describe "expired()" do
  it "should return true when the parameter is older than the number of months in the class threshold constant" do
    threshold = ResQualdoc::ExpiryThreshold
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => (threshold + 1).months.ago)
    res_qualdoc.expired?.should ==true
  end

  it "should return true if the parameter is nil" do
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => nil)
    res_qualdoc.expired?.should ==true
  end

  it "should return false when the parameter is more recent than the number of months in the class threshold constant" do
    threshold = ResQualdoc::ExpiryThreshold
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:days => 1))
    res_qualdoc.expired?.should ==false
  end
end

describe "expiring()" do
  it "should return true when the parameter is in the window between the threshold and two weeks more recent than the threshold" do
    threshold = ResQualdoc::ExpiryThreshold
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:days => 1).to_date)
    res_qualdoc.expiring?.should ==true
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:days => 14).to_date)
    res_qualdoc.expiring?.should ==true
  end

  it "should return false when the parameter is outside the window between the threshold and two weeks more recent than the threshold" do
    threshold = ResQualdoc::ExpiryThreshold
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:days => -1).to_date)
    res_qualdoc.expiring?.should ==false
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:days => 15).to_date)
    res_qualdoc.expiring?.should ==false
  end

  it "should return false when the parameter is nil" do
    res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => nil)
    res_qualdoc.expiring?.should ==false
  end
end

describe "#qualification_vector" do
  context "when date has expired" do
    before(:each) do
      threshold = ResQualdoc::ExpiryThreshold
      res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => (threshold + 1).months.ago) # expired
      @vector = res_qualdoc.qualification_vector
    end

    it "keys should be hashes with keys 'expired' and 'expiry_date'" do
      [:doctype, :expired?, :expiry_date].each do |kk|
        @vector.keys.should include(kk)
      end
    end

    it "values of expired? should be 'true'" do
      @vector[:expired?].should  == true
    end

    it "value of expiry_date should be a Date object" do
      @vector[:expiry_date].should be_kind_of(Date)
    end

    it "value of type should be res" do
      @vector[:doctype].should == 'res'
    end
  end

  context "when date has not expired" do
    before(:each) do
      threshold = ResQualdoc::ExpiryThreshold
      res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => threshold.months.ago.advance(:weeks => 1)) # valid but expiring soon
      @vector = res_qualdoc.qualification_vector
    end

    it "keys should be hashes with keys 'expired' and 'expiry_date'" do
      [:doctype, :expired?, :expiry_date].each do |kk|
        @vector.keys.should include(kk)
      end
    end

    it "values of expired? should be 'false'" do
      @vector[:expired?].should  == false
    end

    it "value of expiry_date should be a Date object" do
      @vector[:expiry_date].should be_kind_of(Date)
    end

    it "value of doctype should be res" do
      @vector[:doctype].should == 'res'
    end
  end

  context "when date is missing" do
    before(:each) do
      res_qualdoc = FactoryGirl.build(:res_qualdoc, :date => nil ) # missing
      @vector = res_qualdoc.qualification_vector
    end

    it "keys should be hashes with keys 'expired' and 'expiry_date'" do
      [:expired?, :expiry_date].each do |kk|
        @vector.keys.should include(kk)
      end
    end

    it "values of expired? should be 'true'" do
      @vector[:expired?].should  == true
    end

    it "value of expiry_date should be nil" do
      @vector[:expiry_date].should be_nil
    end

    it "value of doctype should be res" do
      @vector[:doctype].should == 'res'
    end
  end
end

describe "#current? method" do
  it "should return true if the date is more recent than threshold months ago" do
    rq = FactoryGirl.build(:res_qualdoc, :date => 1.month.ago)
    rq.current?.should ==true
  end

  it "should return false if the date is less recent than threshold months ago" do
    rq = FactoryGirl.build(:res_qualdoc, :date => 7.months.ago)
    rq.current?.should ==false
  end
end
