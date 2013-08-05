class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :image, :description, :content_type, :file_size, :updated_at, :is_main, :is_cover
  mount_uploader :image, ImageUploader

  validates_presence_of :image, :message => 'is required', :if => :image_present?

  def image_present?
    image.try(:file).nil?
  end
end