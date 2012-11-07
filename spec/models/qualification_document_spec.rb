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
    client = FactoryGirl.create(:client_with_current_id)
    client.id_qualdoc.belongs_to?(client).should == true
    another_client = FactoryGirl.create(:client_with_current_id)
    client.id_qualdoc.belongs_to?(another_client).should == false
  end

  it "should return true if it's an ResQualdoc for the passed-in client's household" do
    household = FactoryGirl.create(:household_with_docs)
    client = FactoryGirl.build(:client_with_current_id, :household => household)
    household.clients << client
    household.res_qualdoc.belongs_to?(client).should == true
  end

  it "should return true if it's an GovQualdoc for the passed-in client's household" do
    household = FactoryGirl.create(:household_with_docs)
    client = FactoryGirl.build(:client_with_current_id, :household => household)
    household.clients << client
    household.gov_qualdoc.belongs_to?(client).should == true
  end

  it "should return true if it's an IncQualdoc for the passed-in client's household" do
    household = FactoryGirl.create(:household_with_docs)
    client = FactoryGirl.build(:client_with_current_id, :household => household)
    household.clients << client
    household.inc_qualdoc.belongs_to?(client).should == true
  end

  it "should return false if it's an IdQualdoc and does not belong to the passed-in client" do
    client = FactoryGirl.build(:client_with_current_id)
  end
end

describe "docfile attribute" do
  it "should be an instance of DocfileUploader" do
    qd = ResQualdoc.new(:docfile => 'foo.pdf')
    qd.docfile.should be_kind_of(DocfileUploader)
  end

  it "present? method should respond true if the file is present in the filesystem" do
    filename = Rails.root.join("tmp","foo.txt")
    ff = File.open(filename, "w+")
    qd = ResQualdoc.new(:docfile => ff)
    qd.save
    qd.docfile.present?.should == true
    `rm -f #{qd.docfile.path}`
    qd.docfile.present?.should == false
    `rm -f #{filename}` # cleanup
  end
end

describe "#remove_document" do
  before(:all) do
    @doc = FactoryGirl.create(:res_qualdoc)
  end

  it "should remove the file from the filesystem" do
    @doc.docfile.present?.should be_true
    @doc.remove_file
    @doc.docfile.present?.should be_false
  end
end

# testing my test tools here!
describe "FactoryGirl qualification document" do
  context "using create strategy" do
    before(:all) do
      `rm -f tmp/factory*`
      @doc = FactoryGirl.create(:res_qualdoc)
    end

    it "should create a qualification document instance in the database" do
      ResQualdoc.find(@doc.id).should be_true
    end

    it "should create a file document in the filesystem" do
      # for test env the file location is features/support/uploaded_files
      @doc.docfile.present?.should == true
    end

    it "should remove the source file from the filesystem" do
      # can only match part of the file name as they also have a random component
      Dir.new(Rails.root.join("tmp")).entries.any?{|e| e.match /factory_res_qualdoc/}.should == false
    end
  end

  context "using build strategy" do
    before(:all) do
      `rm -f tmp/factory*`
      @doc = FactoryGirl.build(:res_qualdoc)
    end

    it "should not create a qualification document instance in the database" do
      @doc.id.should be_nil
    end

    it "should not create a file document in the filesystem" do
      # for test env the file location is features/support/uploaded_files
      @doc.docfile.should be_blank
    end

    it "should not create a source file" do
      # can only match part of the file name as they also have a random component
      Dir.new(Rails.root.join("tmp")).entries.any?{|e| e.match /factory_res_qualdoc/}.should == false
    end
  end
end
