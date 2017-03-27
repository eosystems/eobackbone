require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eobackbone
  class Application < Rails::Application
    config.autoload_paths +=%W(#{config.root}/app/models/master)
    config.autoload_paths +=%W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.time_zone = 'Tokyo'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_job.queue_adapter = :delayed_job
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += Dir["#{config.root}/lib/",
                                 "#{config.root}/lib/inputs",
                                 "#{config.root}/app/uploaders",
                                 "#{config.root}/jobs",
                                 "#{config.root}/representers",
                                 "#{config.root}/services"]

    config.generators do |g|
      g.helper false
      g.stylesheets false
      g.javascripts false
    end
  end
end
