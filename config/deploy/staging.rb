server "50.116.8.32", :web, :app, :db, primary: true
set :deploy_env, 'staging'
set :rails_env, 'staging'
set :branch, "dev"