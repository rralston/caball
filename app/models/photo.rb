class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :image, :file_name, :content_type, :file_size, :updated_at
  mount_uploader :image, ImageUploader
end