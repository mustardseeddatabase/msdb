require 'spec_helper'

describe "ancestors method" do
  before(:each) do
    @big_boss = Role.create(:name => "big_boss", :parent_id => nil)
    @boss = Role.create(:name => "boss", :parent_id => @big_boss.id)
    @minion = Role.create(:name => "minion", :parent_id => @boss.id)
  end

  it "minions ancestors should include boss and big boss" do
    @minion.ancestors.should include(@boss)
    @minion.ancestors.should include(@big_boss)
    @minion.ancestors.size.should == 2
    @boss.ancestors.should include(@big_boss)
    @boss.ancestors.size.should == 1
    @big_boss.ancestors.should be_empty
  end

end

describe "equal_or_lower_than class method" do
  before(:each) do
    @big_boss = Role.create(:name => "big_boss", :parent_id => nil)
    @boss = Role.create(:name => "boss", :parent_id => @big_boss.id)
    @minion = Role.create(:name => "minion", :parent_id => @boss.id)
  end

  it "should return minion and boss when parameter is 'boss'" do
    Role.equal_or_lower_than(@boss).should include(@minion)
    Role.equal_or_lower_than(@boss).should include(@boss)
  end

  it "should return minion and boss and big_boss when parameter is an array ['boss','big_boss']" do
    Role.equal_or_lower_than([@boss, @big_boss]).should include(@minion)
    Role.equal_or_lower_than([@boss, @big_boss]).should include(@boss)
    Role.equal_or_lower_than([@boss, @big_boss]).should include(@big_boss)
  end
end
