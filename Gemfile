# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.2.2'

gem 'rails', '~> 7.0.5'

gem 'pg' # database
gem 'puma' # webserver for development
gem 'bcrypt' # password hashing

gem 'sprockets-rails' # asset pipeline
gem 'jsbundling-rails' # bundle and transpile JavaScript
gem 'cssbundling-rails' # bundle and process CSS
gem 'sassc-rails' # use Sass to process CSS
gem 'haml-rails' # haml as template engine

gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'generated_schema_validations' # validate models by schema
gem 'rails_log_parser' # to analyise log

# background jobs
gem 'daemons'
gem 'delayed_job_active_record'
gem 'delayed_job_schedule'
gem 'whenever'

group :production do
  gem 'unicorn' # compiled webserver
end

group :development, :test do
  gem 'debug' # debugger

  gem 'rspec-rails' # test framework
  # code beautifier
  gem 'rubocop'
  gem 'rubocop-daemon'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  gem 'simplecov', require: false # test coverage
end

group :development do
  gem 'web-console' # Use console on exceptions pages

  gem 'capistrano-rsync-plugin', git: 'https://github.com/Lichtbit/capistrano-rsync-plugin' # speed up deploying
  gem 'm3_capistrano3', git: 'git@gitlab.lichtbit.com:lichtbit/m3_capistrano3.git' # deploying tool
end
