require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist

  config.include FeatureHelper, type: :feature
  config.include OmniauthHelper, type: :feature

  config.use_transactional_fixtures = false

  # Configuration Database_cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    OmniAuth.config.mock_auth[:twitter] = nil
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true
