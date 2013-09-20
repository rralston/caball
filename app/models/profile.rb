class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :image, :content_type, :file_size, :updated_at,
                  :crop_x, :crop_y, :crop_w, :crop_h, :original_width, :original_height
  mount_uploader :image, ImageUploader

  after_update :reprocess_profile, :if => :cropping?
  # validates_presence_of :image, :message => 'is required', :if => :image_present?

  before_save :save_original_size, :if => :image_object_present?
  
  def save_original_size
    if Rails.env == 'development'
      begin
        geometry = Magick::Image::read(Rails.root.join('public').to_s + image.url).first
      rescue
        geometry = Magick::Image::read(image.url).first
      end
    else  
      geometry = Magick::Image::read(image.url).first
    end

    if (!geometry.nil?)
      self.original_width = geometry.columns
      self.original_height = geometry.rows
    end
  end

  def image_object_present?
    image.present?
  end

  # def image_present?
  #   image.try(:file).nil? and is_cover == false
  #   # no need to validate presence of image if that is a cover photo.
  #   # cover photo is optional for user.
  # end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def reprocess_profile
    self.image.recreate_versions!
  end

end