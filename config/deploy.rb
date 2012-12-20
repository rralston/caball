set :stages, %w(production staging)
set :default_stage, "staging"

require "bundler/capistrano"
require "cap_bootstrap/capistrano"
require 'capistrano/ext/multistage'

set(:domain) { "#{application}.net" }
set :ruby_version, "1.9.3-p194"

set :user, "deployer"
set :application, "caball"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, "git"
set :repository, "git@github.com:rralston/#{application}.git"
set :port, 30128

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases