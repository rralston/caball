# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    
    # Profiles doesn't have an "imageable_type", but photos do
    begin
      "/images/fallback/#{model.imageable_type}_" + [version_name, "default.png"].compact.join('_')
    rescue Exception => e
      "/images/fallback/#{model}_" + [version_name, "default.png"].compact.join('_')
    end
  end


  # Create thumb version of uploaded files:
  # Accessible through <%= image_tag @user.photo.image.url(:thumb)  %>
   version :thumb do
     process :resize_to_fill => [25, 25]
   end
   
   # Create Medium Sized Version
   # Accessible through <%= image_tag @user.photo.image.url(:medium)  %>
    version :medium do
      process :resize_to_fill => [100, 100]
    end
   
   version :large do
     process :resize_to_fill => [400, 400]
   end

  # White list of extensions which are allowed to be uploaded.
   def extension_white_list
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
   def filename
     "Profile_Image.jpg" if original_filename
   end
  
  process :resize_to_fill => [400, 400]

end
