Given /^there are (\d+) items in the database each with qoh greater than (\d+)$/ do |arg1, arg2|
  5.times do
    FactoryGirl.create(:item)
  end
end

Then /^(\d+) items in the database should have qoh (\d+)$/ do |count, value|
  sleep(0.4)
  Item.all.select{|item| item.qoh == value.to_i}.size.should == count.to_i
end

