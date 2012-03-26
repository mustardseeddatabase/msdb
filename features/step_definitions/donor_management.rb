Given /^There is a donor organization "([^"]*)" in the database$/ do |name|
  FactoryGirl.create(:donor, :organization => name)
end
