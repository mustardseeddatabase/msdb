require 'spec_helper'

describe "Sessions" do
  describe "GET /" do
    it "should show the login page" do
      get root_path
      response.status.should be(200)
      response.body.should include("Please log in")
    end
  end
end
