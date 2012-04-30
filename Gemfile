# official unofficial ruby-debug19 fix
# with the same gems as mentioned in 
# https://gist.github.com/1333785

source 'https://gems.gemfury.com/8n1rdTK8pezvcsyVmmgJ/' 


source 'http://rubygems.org'

gem "rails", "~> 3.1.3"
gem "mysql2" #, "0.3.2"
# Rails 3.1 - JavaScript
gem 'jquery-rails'

gem 'haml', :git => 'git://github.com/infbio/haml.git', :branch => 'form_for_fix' # fixes a form_for issue in haml
#gem 'haml'
gem 'haml-rails'
gem 'message_block', :git => 'git://github.com/lazylester/message_block.git'
gem 'authengine', :git => 'git://github.com/mustardseeddatabase/authengine.git'
#gem 'authengine', :path => '/Users/lesnightingill/Code/authengine'
gem 'db_check', :path => 'vendor/gems/db_check'
gem 'carrierwave' #, :git => 'git://github.com/jnicklas/carrierwave.git' # until version 0.6 is available, this avoids deprecation warnings in Rspec tests related to memoization
gem 'delegate_multiparameter', :path => 'vendor/gems/delegate_multiparameter'
gem 'client_side_validations'
gem 'haml_assets', :git => 'git://github.com/infbio/haml_assets.git' # to use haml with backbone assets
gem 'ejs', :git => 'git://github.com/sstephenson/ruby-ejs.git'
gem 'sprockets', '~> 2.0'

# Gems only required for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "3.1.4" # due to rake 'stack level too deep' failure, this constraint can be removed when the fix is in sass-rails
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'execjs'
  gem 'therubyracer'
end

group :development, :test do
  gem 'faker', :git => 'git://github.com/stympy/faker.git' # due to an I18n problem after updating to Rails 3.1
  gem 'spork', '~> 0.9.0.rc'
  gem 'sqlite3-ruby'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'cucumber-rails', '>=0.5.1'
  #gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'capybara-webkit', :git => "git://github.com/thoughtbot/capybara-webkit.git" #, :branch => '1.0'
  gem 'selenium-webdriver', '2.0.1'
  gem 'factory_girl_rails'


  # official unofficial ruby-debug19 fix
  # with the same gems as mentioned in 
  # https://gist.github.com/1333785
  gem 'linecache19',       '>= 0.5.13'
  gem 'ruby-debug-base19', '>= 0.11.26'
  gem 'ruby-debug19'


  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'flexmock'
  gem 'mocha'
  gem 'capistrano'
  gem 'active_reload'
  gem 'jasmine'
  gem 'jasminerice'
end
