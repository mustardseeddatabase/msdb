require 'rails'

module ENGINE_NAME
  class Engine < Rails::Engine
    isolate_namespace ENGINE_NAME
    config.mount_at = '/'
  end
end


