require 'cucumber/rails'
require 'faker'
require File.join(File.dirname(__FILE__),'step_helpers.rb')
require 'flexmock'
include FlexMock::MockContainer

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
# Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove this line if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'ruby-debug'
DatabaseCleaner.strategy = :truncation # required for Selenium
Before do
  DatabaseCleaner.start
  DatabaseCleaner.clean
end

After do
  DatabaseCleaner.clean
  `rm -f features/support/uploaded_files/*`
end

#require 'capybara/envjs'
Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 5
#Capybara.register_driver :selenium do |app|
  ## driver installed from http://code.google.com/p/selenium/downloads/list
  ## installed in /usr/local/bin/
  #Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end


require 'factory_girl_rails'
Dir.new(File.join(Rails.root,'spec','factories')).entries.reject{|f| f.match(/^./)}.each { |f| require f }

require 'email_spec'
require 'email_spec/cucumber'
