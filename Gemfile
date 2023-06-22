source "https://rubygems.org"
ruby "3.2.2"

gem "rails", "~> 7.0.5"

gem "pg" # database
gem "puma" # webserver for development
gem "bcrypt" # password hashing

gem "sprockets-rails" # asset pipeline
gem "jsbundling-rails" # bundle and transpile JavaScript
gem "sassc-rails" # use Sass to process CSS

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb

group :development, :test do
  gem 'debug' # debugger
end

group :development do
  gem "web-console" # Use console on exceptions pages
end

