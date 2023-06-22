# frozen_string_literal: true

if ENV['CI_SERVER'].nil?
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = false

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
