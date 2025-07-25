require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Build
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.i18n.default_locale = :it

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])
    config.assets.paths << Rails.root.join('app', 'assets', 'images')
    config.assets.compile = true
    # Configuration for the application, engines, and railties goes here.
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_lib(ignore: %w(assets tasks))
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    Dotenv::Rails.load

    # config.middleware.use Rack::Logger

  end
end
