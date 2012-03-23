Given /^there is an inventory created on (.+) in the database$/ do |date|
  Factory.create(:inventory, :created_at => Date.parse(date))
end

Then /^I should see (\d+) inventory items$/ do |count|
  page.all(:css, ".transaction_item").length.should == count.to_i
end

