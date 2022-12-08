require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CURIOSity
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: ENV.fetch('APP_HOST', nil), from: 'curiosity-noreply@harvard.edu', protocol: 'https' }
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.exceptions_app = self.routes
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_job.queue_adapter = :delayed_job

    config.rack_cas.server_url = 'https://www.pin1.harvard.edu/cas' # replace with your server URL
    config.rack_cas.service = '/users/service' # If your user model isn't called User, change this
    config.to_prepare do
      # Allows us to use decorator files
      Dir.glob(File.join(File.dirname(__FILE__), '../app/**/*_decorator*.rb')).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
  end
end
