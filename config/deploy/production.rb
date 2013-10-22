server "192.155.85.156", :web, :app, :db, primary: true
set :deploy_env, 'production'
set :rails_env, 'production'
set :branch, "dev"