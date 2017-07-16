require_relative 'boot'

require 'rails/all'
require 'wicked_pdf'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trainapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.cache_store = :redis_store, "#{ENV["REDIS_URL"]}/1/cache", { expires_in: 90.minutes }
    config.middleware.use Rack::Attack
    config.middleware.use WickedPdf::Middleware, {}, only: 'home/ticketconfirmation'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
