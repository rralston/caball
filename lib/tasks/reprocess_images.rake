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


namespace :images do
  task :reprocess_all => :environment do
    Photo.all.each  do |photo|
      puts "resizing photo - #{photo.id}"
      begin
        photo.reprocess_profile
      rescue
      end
    end

    Profile.all.each  do |photo|
      puts "resizing profile photo - #{photo.id}"
      begin
        photo.reprocess_profile
      rescue
      end
    end

  end
end