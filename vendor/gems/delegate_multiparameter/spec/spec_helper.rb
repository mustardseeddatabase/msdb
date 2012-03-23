ENV["RAILS_ENV"] ||= 'test'
require 'mocha'

require File.join(File.dirname(__FILE__), "../../../../config/environment")

RSpec.configure do |config|
  config.mock_with :mocha
end

