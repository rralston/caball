server "192.155.85.156", :web, :app, :db, primary: true
set :deploy_env, 'staging'
set :rails_env, 'staging'
set :branch, "dev"