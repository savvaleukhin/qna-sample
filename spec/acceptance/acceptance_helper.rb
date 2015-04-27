require'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.default_wait_time = 10

  config.include FeatureHelper, type: :feature

  config.use_transactional_fixtures = false

  # Configuration Database_cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
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