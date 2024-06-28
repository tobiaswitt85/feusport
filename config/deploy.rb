# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17'

set :application, 'feusport'
set :repo_url, 'git@github.com:Feuerwehrsport/feusport.git'
set :deploy_to, '/srv/feusport'

set :branch, 'main'

set :rvm_ruby_version, '3.2.4'
set :migration_servers, -> { release_roles(fetch(:migration_role)) }

# set :enable_delayed_job, true # default is true
# set :enable_whenever, true # default is true

set :systemd_usage, true
