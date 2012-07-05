require 'rails'

module SummaryReport
  class Engine < Rails::Engine
    isolate_namespace SummaryReport
    config.mount_at = '/'
  end
end


