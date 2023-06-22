# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17'

set :application, 'feusport-live'
set :repo_url, 'git@github.com:Feuerwehrsport/feusport-live.git'
set :deploy_to, '/srv/feusport-live'

set :branch, 'main'

set :rvm_ruby_version, '3.2.2'
set :migration_servers, -> { release_roles(fetch(:migration_role)) }

# set :enable_delayed_job, true # default is true
# set :enable_whenever, true # default is true

set :systemd_usage, true
