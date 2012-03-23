Given /^There is a donor organization "([^"]*)" in the database$/ do |name|
  Factory.create(:donor, :organization => name)
end
