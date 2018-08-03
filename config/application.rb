require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImiqMap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = 'Alaska'

    config.action_mailer.default_url_options = { host: 'imiq-map.gina.alaska.edu' }

    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "IMIQ_#{Rails.env}"
  end
end
