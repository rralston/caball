# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  if Rails.env.test? or Rails.env.cucumber? or Rails.env.development?
    storage :file
  else
    storage :fog
  end
  
  # storage :file Previously before CDN for Heroku

  def cache_dir
      "#{Rails.root}/tmp/uploads"
  end
    
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if model.class.name == 'Profile'
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.imageable.class.name}/#{mounted_as}/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    puts YAML::dump(model)
    puts YAML::dump(model.respond_to?('imageable_type'))
    #raise "very confusing ... model.class = " + model.class.to_s + " version = " + version_name
    if model.respond_to?('imageable_type')
      "/images/fallback/#{model.imageable_type.to_s}_" + [version_name, "default.png"].compact.join('_')
    else
      "/images/fallback/#{model.class.to_s}_" + [version_name, "default.png"].compact.join('_')
    end
  end

  # process :manualcrop

  version :original do
    process :manualcrop
  end

  # Create thumb version of uploaded files:
  # Accessible through <%= image_tag @user.photo.image.url(:thumb)  %>
  version :thumb do
    process :manualcrop
    process :resize_to_fill => [25, 25]
  end
   
   # Create Medium Sized Version
   # Accessible through <%= image_tag @user.photo.image.url(:medium)  %>
  version :medium do
    process :manualcrop
    process :resize_to_fill => [170, 170]
  end
   
  version :large do
    process :manualcrop
    process :resize_to_fill => [400, 400]
  end
   
  version :tiny do
    process :manualcrop
    process :resize_to_fill => [40, 40]
  end

  


  def manualcrop
    debugger
    return unless model.cropping?
    manipulate! do |img| 
      img = img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_w.to_i,model.crop_h.to_i) 
    end 
  end

  # White list of extensions which are allowed to be uploaded.
   def extension_white_list
     %w(jpg jpeg png)
   end

  # Override the filename of the uploaded files:
   def filename
      original_filename
   end
  
  # process :resize_to_fill => [400, 400]

end
