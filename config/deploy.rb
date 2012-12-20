set :stages, %w(production staging)
set :default_stage, "production"

require "bundler/capistrano"
require "cap_bootstrap/capistrano"
require 'capistrano/ext/multistage'

server "192.155.85.156", :web, :app, :db, primary: true

set(:domain) { "#{application}.net" }
set :ruby_version, "1.9.3-p194"

set :user, "deployer"
set :application, "caball"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, "git"
set :repository, "git@github.com:rralston/#{application}.git"
set :branch, "dev"
set :port, 30128

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end