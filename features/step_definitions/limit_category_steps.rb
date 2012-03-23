When /^I fill in "([^"]*)" for category "([^"]*)" and family size "([^"]*)"$/ do |value, category, res_count|
  fill_in "#{category}_threshold_#{res_count}", :with => value
end

Then /^the category threshold for category "([^"]*)" and family size "([^"]*)" should be "([^"]*)"$/ do |category, res_count, value|
  LimitCategory.find_by_name(category).category_thresholds.detect{|ct| ct.res_count == res_count.to_i}.threshold.should == value.to_i
end
