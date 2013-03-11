class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :image, :description, :content_type, :file_size, :updated_at, :md5hash
  before_validation :compute_hash
  validates_uniqueness_of :md5hash, :on => :create
  mount_uploader :image, ImageUploader  

  def compute_hash
    self.md5hash = Digest::MD5.hexdigest(self.image.read)
  end
end