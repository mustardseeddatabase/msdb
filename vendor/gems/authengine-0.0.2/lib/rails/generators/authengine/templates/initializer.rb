ActiveRecord::Base.observers = :user_observer
Rails::Application.config.filter_parameters += [:password]
require 'constants'
