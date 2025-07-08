# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

# === Capybara / Selenium Chrome Headless ===
Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,900')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_preference('profile.default_content_setting_values.geolocation', 1) # Consenti geolocalizzazione

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :chrome_headless
Capybara.default_driver = :chrome_headless
Capybara.default_max_wait_time = 15

# === Per Firefox, eventualmente ===
# Capybara.register_driver :firefox_headless do |app|
#   options = Selenium::WebDriver::Firefox::Options.new
#   options.add_argument('--headless')
#
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   profile['geo.prompt.testing'] = true
#   profile['geo.prompt.testing.allow'] = true
#   options.profile = profile
#
#   Capybara::Selenium::Driver.new(
#     app,
#     browser: :firefox,
#     options: options
#   )
# end
#
# Capybara.javascript_driver = :firefox_headless
# Capybara.default_driver = :firefox_headless

# === Carica file support (helpers, macro ecc.)
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Ensures that the test database schema matches the current schema file.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # config.filter_gems_from_backtrace("gem name")
end
