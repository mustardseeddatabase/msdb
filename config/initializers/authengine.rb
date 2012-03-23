ActiveRecord::Base.observers = :user_observer
Msdb::Application.config.filter_parameters += [:password]
require 'constants'
