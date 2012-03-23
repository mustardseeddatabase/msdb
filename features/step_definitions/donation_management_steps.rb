Given /^There is a donor called "([^"]*)" in the database$/ do |name|
  Factory.create(:donor, :organization => name)
end

Given /^There are ten donations in the database$/ do
  w = 1
  10.times do
    donor = Factory.create(:donor)
    Factory.create(:donation, :created_at => w.weeks.ago, :donor_id => donor.id)
    w += 1
  end
end

Then /^I should see (\d+) donations$/ do |count|
  row_count = page.find(:css, '#donations').all(:xpath,'./tr').count
  (row_count - 1).should == count.to_i # because there's a header row
end
