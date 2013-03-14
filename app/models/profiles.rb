class Profiles < ActiveRecord::Base
  belongs_to :imageable, :user
  attr_accessible :image, :file_name, :content_type, :file_size, :updated_at
  mount_uploader :image, ImageUploader
end