class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :image, :description, :content_type, :file_size, :updated_at, :is_main
  mount_uploader :image, ImageUploader

  validates_presence_of :image, :message => 'is required'
end