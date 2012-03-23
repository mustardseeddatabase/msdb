require 'spec_helper'
describe "initialization" do
  it "should initialize a new instance" do
    search = HouseholdSearch.new(:city => "Amsterdam", :zip => '70022', :address => "Hauptstrasse", :client_name => "Van Gogh")
    search.city.should == "Amsterdam"
    search.zip.should == "70022"
    search.address.should == "Hauptstrasse"
    search.client_name.should == "Van Gogh"
  end
end

describe "#search_terms method" do

  it "should return a hash of search terms" do
    search = HouseholdSearch.new(:city => "Amsterdam", :zip => '70022', :address => "Hauptstrasse", :client_name => "Van Gogh")
    search.search_terms.should =={"city:" => "Amsterdam", "zip code:" => "70022", "street name:" => "Hauptstrasse", "client last name:" => "Van Gogh"}
  end

  it "should return a string of search terms" do
    search = HouseholdSearch.new(:city => "Amsterdam", :zip => '70022', :address => "Hauptstrasse", :client_name => "Van Gogh")
    search.search_terms.to_s.split(", ").each do |term|
      "street name: Hauptstrasse, zip code: 70022, client last name: Van Gogh, city: Amsterdam".should match(/#{term}/)
    end
  end

  it "should return a hash of search terms without entries omitted" do
    search = HouseholdSearch.new(:zip => '70022', :address => "Hauptstrasse", :client_name => "Van Gogh", :city => nil)
    search.search_terms.should =={"zip code:" => "70022", "street name:" => "Hauptstrasse", "client last name:" => "Van Gogh"}
  end
end

describe "#blank? method" do
  it "should return true if all initialization parameters are blank" do
    search = HouseholdSearch.new(:city => '', :zip => '', :address => "", :client_name => "")
    search.blank?.should ==true
  end

  it "should return false if any initialization parameters are not blank" do
    search = HouseholdSearch.new(:city => 'Dungeness', :zip => '', :address => "", :client_name => "")
    search.blank?.should ==false
  end
end

describe "#to_params method" do
  it "should return a hash of parameters with keys suitable for consumption by the households_controller#index action" do
    search = HouseholdSearch.new(:city => "Amsterdam", :zip => '70022', :address => "Hauptstrasse", :client_name => "Van Gogh")
    search.to_params[:household_search][:city].should        == 'Amsterdam'
    search.to_params[:household_search][:zip].should         == '70022'
    search.to_params[:household_search][:address].should     == 'Hauptstrasse'
    search.to_params[:household_search][:client_name].should == 'Van Gogh'
  end
end
