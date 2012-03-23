# included for reference... these steps are already included in
# cucumber-rails-1.0.2/lib/cucumber/rails/capybara/select_dates_and_times.rb
# but REMOVED in cucumber-rails-1.1.1 !
When /^(?:|I )select "([^"]+)" as the "([^"]+)" time$/ do |time, selector|
  #select_time(selector, :with => time)
  select_time(date, :from => selector)
end

When /^(?:|I )select "([^"]+)" as the "([^"]+)" date$/ do |date, selector|
  #select_date(selector, :with => date) # old format
  select_date(date, :from => selector)
end

When /^(?:|I )select "([^"]+)" as the "([^"]+)" date and time$/ do |datetime, selector|
  #select_datetime(selector, :with => datetime) # old format
  select_datetime(date, :from => selector)
end

