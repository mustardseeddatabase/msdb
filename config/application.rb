require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'sprockets/railtie'
require File.expand_path('../../lib/constants', __FILE__)

# Rails 3.0.x:
# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env) if defined?(Bundler)

if defined?(Bundler)
  # if you precompile assets before deploying to production, use this line:
  Bundler.require *Rails.groups(:assets => %w(development test))
  # if you want your assets lazily compiled in production, use this line:
  # Bundler.require(:default, :assets, Rails.env)
end

module Msdb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Enable the asset pipeline
    config.assets.enabled = true

    # the following lines seem to be required after upgrade to Rails 3.2.5 (bug?) It's a workaround for assets not being found
    config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
    config.assets.paths << Rails.root.join("app", "assets", "javascripts")
    config.assets.paths << Rails.root.join("vendor", "assets", "stylesheets")
    config.assets.paths << Rails.root.join("vendor", "assets", "javascripts")
    config.assets.paths << Rails.root.join("lib", "assets", "javascripts")
    config.assets.paths << Authengine::Engine.root.join("app", "assets", "stylesheets")
    config.assets.paths << Authengine::Engine.root.join("app", "assets", "images")
    config.assets.paths << Jquery::Rails::Engine.root.join("vendor", "assets", "javascripts")
    config.assets.paths << Rails.root.join("app", "themes", "default", "assets")
    config.assets.paths << Rails.root.join("app", "themes", "default", "assets", "images")
    config.assets.paths << Rails.root.join("spec", "javascripts")

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    #I18n.load_path += Dir[Rails.root.join("config","locales","*.yml")] # in order to use the i18n theme control this early in the boot

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    # config.filter_parameters += [:password]

    config.generators do |g|
    # Configure haml to be the default templating engine for generators
      g.template_engine :haml
    end

    config.action_mailer.default_url_options = {:host => SITE_URL}

  end
end
