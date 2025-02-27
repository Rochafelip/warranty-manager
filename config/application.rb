require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WarrantyManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.middleware.use ActionDispatch::Cookies

    config.api_only = true
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_warranty_manager_session'

    #ActiveJob
    config.active_job.queue_adapter = :sidekiq

    # Internationalization (I18n) Configuration
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en pt-BR]
  end
end
