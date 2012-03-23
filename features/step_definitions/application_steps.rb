Then /^There should be "([^"]*)" "([^"]*)" in the database$/ do |count, model|
  sleep(0.1)
  model.classify.constantize.send('count').should == count.to_i
end

When /^I fill in autocomplete "([^"]*)" with "([^"]*)"$/ do |selector, value|
  fill_in_autocomplete(selector, value)
end

When /^I click autocomplete result "([^"]*)"$/ do |text|
  choose_autocomplete(text)
end
# for reference:
  #def fill_in_autocomplete(selector, value)
    #page.execute_script %Q{$('#{selector}').val('#{value}').keydown()}
  #end

  #def choose_autocomplete(text)
    #find('ul.ui-autocomplete').should have_content(text)
    #page.execute_script("$('.ui-menu-item:contains(\"#{text}\")').find('a').trigger('mouseenter').click()")
  #end
