class Profiles < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :image, :file_name, :content_type, :file_size, :updated_at
  mount_uploader :image, ImageUploader
end