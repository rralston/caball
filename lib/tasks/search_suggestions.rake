namespace :search_suggestions do
  desc "Generate search suggestions from Database"
  task :index => :environment do
    SearchSuggestion.index_users
  end
end