namespace :profile  do
  task :update_dimensions => :environment do
    Profile.all.each  do |profile|
      profile.save_original_size
      profile.save
    end
  end
end


namespace :photo  do
  task :update_dimensions => :environment do
    Photo.where(:imageable_type => nil).destroy_all
    Photo.all.each  do |photo|
      puts photo.id
      begin
        photo.save_original_size
        photo.save
      rescue
      end
    end
  end
end