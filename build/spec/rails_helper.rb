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
Capybara.register_driver :firefox_headless do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('--headless')

  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['geo.prompt.testing'] = true
  profile['geo.prompt.testing.allow'] = true

  options.profile = profile

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options
  )
end


Capybara.javascript_driver = :firefox_headless
Capybara.default_driver = :firefox_headless
Capybara.default_max_wait_time = 5


# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
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

  config.before(:each, type: :system) do
    driven_by :firefox_headless
  end
end
