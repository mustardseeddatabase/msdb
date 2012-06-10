Given /^I am logged in and on the "([^"]*)" page for "([^"]*)"$/ do |page, name|
  steps %Q{ Given I am logged in with "admin" role
            And permission is granted for "admin" to go to the "#{page}" page
            And I am on the #{page} page for "#{name}"}
end

Then /^The distribution item in the database should have quantity (\d+)$/ do |count|
  DistributionItem.first.quantity.should == count.to_i
end

Then /^There should be no errors reported$/ do
  find(:css, '#error_message').text.should == ""
end

Given /^The limit for category "([^"]*)" for a household size of "([^"]*)" is "([^"]*)"$/ do |category, household_size, limit|
  cat = LimitCategory.find_by_name(category)
  cat_threshold = cat.category_thresholds.detect{|ct| ct.res_count == household_size.to_i}
  cat_threshold.threshold = limit.to_i
  cat_threshold.save
end

Then /^The size of the limit bar for category "([^"]*)" should be "([^"]*)"$/ do |category, bar_size|
  sleep(0.2)
  element = find("#limit_categories  ##{category}")
  attributes = element[:style].split(";").inject({}){ |hash,str| ar = str.lstrip.split(":"); hash[ar[0]]=ar[1].lstrip; hash }
  attributes["width"].should == "#{bar_size}px"
end

Then /^The class of the limit bar for category "([^"]*)" should be "([^"]*)"$/ do |category, classname|
  sleep(0.2)
  element = find("#limit_categories  ##{category}")
  element[:class].should match "#{classname}"
end

Given /^The categories, limit_categories and category_thresholds tables are fully populated$/ do
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE categories')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE limit_categories')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE category_thresholds')
  # The following lines truncate the tables when the database is sqlite
  #Category.find_by_sql("delete from sqlite_sequence where name='categories';")
  #LimitCategory.find_by_sql("delete from sqlite_sequence where name='limit_categories';")
  #CategoryThreshold.find_by_sql("delete from sqlite_sequence where name='category_thresholds';")
  categories =[ {:name =>"Food",      :limit_category_name => "Beverages"},
                {:name =>"Food",      :limit_category_name => "Dairy"},
                {:name =>"Food",      :limit_category_name => "Fruits"},
                {:name =>"Food",      :limit_category_name => "Grains"},
                {:name =>"Food",      :limit_category_name => "Meals/Dinners"},
                {:name =>"Clothing",  :limit_category_name => "Other (Non-Food)"},
                {:name =>"Medical",   :limit_category_name => "Other (Non-Food)"},
                {:name =>"Household", :limit_category_name => "Other (Non-Food)"},
                {:name =>"Hygiene",   :limit_category_name => "Other (Non-Food)"},
                {:name =>"Food",      :limit_category_name => "Proteins"},
                {:name =>"Food",      :limit_category_name => "Sauces/Condiments"},
                {:name =>"Food",      :limit_category_name => "Snacks/Desserts"},
                {:name =>"Food",      :limit_category_name => "Soups"},
                {:name =>"Food",      :limit_category_name => "Vegetables"}
                ]
  limit_categories =[ {:name => "Beverages"         , :thresholds => [1,1,1,1,1,1]},
                      {:name => "Dairy"             , :thresholds => [1,1,1,1,1,1]},
                      {:name => "Fruits"            , :thresholds => [3,3,4,4,5,5]},
                      {:name => "Grains"            , :thresholds => [1,1,1,2,2,4]},
                      {:name => "Meals/Dinners"     , :thresholds => [1,1,1,1,1,1]},
                      {:name => "Other (Non-Food)"  , :thresholds => [1,1,1,1,1,1]},
                      {:name => "Proteins"          , :thresholds => [3,3,3,4,4,4]},
                      {:name => "Sauces/Condiments" , :thresholds => [5,5,5,5,5,5]},
                      {:name => "Snacks/Desserts"   , :thresholds => [3,3,3,4,5,5]},
                      {:name => "Soups"             , :thresholds => [2,2,2,3,3,3]},
                      {:name => "Vegetables"        , :thresholds => [11,12,13,16,17,20]}
                    ]
  limit_categories.each do |lc|
    limit_category = LimitCategory.create(:name => lc[:name])
    count = 1
    lc[:thresholds].each do |t|
      limit_category.category_thresholds.create(:res_count => count, :threshold => t)
      count += 1
    end
  end
  categories.each do |cat|
    lc = LimitCategory.find_by_name(cat[:limit_category_name])
    category = Category.create(:name => cat[:name], :limit_category_id => lc.id)
  end
end

Then /^I should see a input field with id "([^"]*)"$/ do |id|
  page.should have_field("#{id}")
end

Then /^There should be a "([^"]*)" item in the list$/ do |count|
  page.all(:css, "#found_in_db tr.transaction_item").size.should == count.to_i
end

Then /^The quantity should be "([^"]*)"$/ do |count|
  page.find(:css, "#found_in_db tr.transaction_item input.quantity").value.to_i.should == count.to_i
end

Then /^"\#error_message' should be blank$/ do
  find(:css, '#error_message').text().should == ""
end
