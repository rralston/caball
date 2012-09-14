server "50.116.8.32", :web, :app, :db, primary: true
set :deploy_env, 'production'
set :rails_env, 'production'
set :branch, "master"