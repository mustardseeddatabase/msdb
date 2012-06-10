require 'rails'

module SecondHarvestMonthlyReport
  class Engine < Rails::Engine
    isolate_namespace SecondHarvestMonthlyReport
    config.mount_at = '/'
  end
end


