class Event < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  acts_as_taggable

  belongs_to :user

  has_many :likes, :as => :loveable, :dependent => :destroy
  has_many :fans, :through => :likes, :source => :user
  has_one :main_photo, :class_name => 'Photo', :as => :imageable, :dependent => :destroy, :conditions => { :is_main => true }
  
  has_many :other_photos, :class_name => 'Photo', :as => :imageable,
           :dependent => :destroy, :conditions => { :is_main => false }
  
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  has_many :other_important_dates, :class_name => 'ImportantDate',
           :as => :important_dateable, :dependent => :destroy, :conditions => { :is_start_date => false, :is_end_date => false }

  has_many :likers, :through => :likes, :source => :user

  has_one :start, :class_name => 'ImportantDate', :as => :important_dateable,
          :dependent => :destroy, :conditions => { :is_start_date => true }
  
  has_one :end, :class_name => 'ImportantDate', :as => :important_dateable,
          :dependent => :destroy, :conditions => { :is_end_date => true }

  has_many :attends, :as => :attendable, :dependent => :destroy
  # has_many :attendees, :through => :attends, :source => :user

  attr_accessible :title, :description, :main_photo_attributes, :other_photos_attributes, :videos_attributes, :website,
                  :location, :other_important_dates_attributes, :user_id, :main_photo,
                  :start_attributes, :end_attributes, :tag_list
  
  accepts_nested_attributes_for :other_photos, :videos, :main_photo,
                                :start, :end, :other_important_dates, :allow_destroy => true  
  
  validates_presence_of :title, :description, :message => "is required"
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode, :if => :location_changed?  # auto-fetch coordinates

  def attendees
    attends.order('created_at').map(&:user)
  end

  def attending?(user)
    attendees.include?(user)
  end

  def liked_by?(user)
    likers.include?(user)
  end

end