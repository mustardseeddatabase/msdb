# official unofficial ruby-debug19 fix
# with the same gems as mentioned in 
# https://gist.github.com/1333785
source 'https://gems.gemfury.com/8n1rdTK8pezvcsyVmmgJ/' 


source 'http://rubygems.org'

gem "rails", "~> 3.2.0"
gem "mysql2"
gem 'jquery-rails'

gem 'haml', :git => 'git://github.com/infbio/haml.git', :branch => 'form_for_fix' # fixes a form_for issue in haml
gem 'haml-rails'
gem 'message_block', :git => 'git://github.com/lazylester/message_block.git'
gem 'authengine', "0.0.2", :git => 'git://github.com/mustardseeddatabase/authengine.git'
gem 'db_check', :path => 'vendor/gems/db_check'
gem 'carrierwave'
gem 'delegate_multiparameter', :path => 'vendor/gems/delegate_multiparameter'
gem 'client_side_validations'
gem 'haml_assets', :git => 'git://github.com/infbio/haml_assets.git' # to use haml with backbone assets
gem 'ejs', :git => 'git://github.com/sstephenson/ruby-ejs.git'
gem 'sprockets'
gem 'rbarcode', :git => 'git://github.com/mustardseeddatabase/rbarcode.git'
gem 'doccex', :git => 'git://github.com/mustardseeddatabase/doccex.git'

# Gems only required for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
  gem 'execjs'
  gem 'therubyracer'
end

group :development, :test do
  gem 'faker', :git => 'git://github.com/stympy/faker.git' # due to an I18n problem after updating to Rails 3.1
  gem 'spork', '~> 0.9.0.rc'
  gem 'sqlite3-ruby'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'cucumber-rails', '>=0.5.1', :require => false
  gem 'capybara-webkit', :git => "git://github.com/thoughtbot/capybara-webkit.git" #, :branch => '1.0'
  gem 'selenium-webdriver', '2.0.1'
  gem 'factory_girl_rails'


  # official unofficial ruby-debug19 fix
  # with the same gems as mentioned in 
  # https://gist.github.com/1333785
  gem 'linecache19',       '>= 0.5.13'
  gem 'ruby-debug-base19', '>= 0.11.26'
  gem 'ruby-debug19'


  #gem 'ruby-debug19', :require => 'ruby-debug' there seems to be a problem with ruby-debug19 and Ruby 1.9.3
  gem 'rspec'
  gem 'rspec-rails'
  gem 'flexmock'
  gem 'mocha'
  gem 'capistrano'
  gem 'active_reload'
  gem 'jasmine'
  gem 'jasminerice'

  gem 'test-unit', :require => 'test/unit' # not actually used! included only to workaround pesky bug, see http://stackoverflow.com/questions/9523931/rake-dbtestprepare-in-rails-3-app-fails-with-file-not-found

  gem 'email_spec' # for testing email with Rspec
end
