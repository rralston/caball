namespace :users  do
  task :reprocess_covers => :environment do
    Photo.where(:is_cover => 1).each  do |photo|
      begin
        photo.reprocess_profile
      rescue
      end
    end
  end
end