Then /^There should be (\d+) item in the item cache$/ do |count|
  sleep(0.3)
  page.evaluate_script("distribution_app.transaction.transaction_items.item_cache.size()").should == count.to_i
end

Then /^There should be (\d+) transaction item(s)? in the application$/ do |count,plural|
  sleep(0.2)
  page.evaluate_script("distribution_app.transaction.transaction_items.size()").should == count.to_i
end

Then /^The item cache item should be configured with "([^"]*)" "([^"]*)"$/ do |attribute, value|
  sleep(0.2)
  numeric_attributes = ["weight_oz", "count"]
  cached_value = page.evaluate_script("distribution_app.transaction.transaction_items.item_cache.first().get('#{attribute}')")
  if numeric_attributes.include?(attribute)
    cached_value.to_i.should == value.to_i
  else
    cached_value.should == value
  end
end

Then /^The item cache item should have a category with the name "([^"]*)"$/ do |cat_name|
  category_id = page.evaluate_script("distribution_app.transaction.transaction_items.item_cache.first().get('category_id')")
  Category.find(category_id).name.should == cat_name
end

