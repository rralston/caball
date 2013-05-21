class User < ActiveRecord::Base
  has_one :characteristics, :dependent => :destroy
  has_one :profiles, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  has_many :friendships
  has_many :friends, through: :friendships
  accepts_nested_attributes_for :profiles, :reject_if => :all_blank
  has_many :comments
  has_many :blogs, :dependent => :destroy
  accepts_nested_attributes_for :characteristics, :photos, :videos, :projects, :talents, :allow_destroy => true
  attr_accessible :name, :email, :location, :about, :profiles, :profiles_attributes, :imdb_url, :characteristics_attributes, :photos_attributes, :talents_attributes, :photo, :videos_attributes, :projects_attributes, :admin, :gender, :headline, :featured
  validates_presence_of :name, :email, :message => "is required"

  acts_as_messageable
    
  geocoded_by :location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
     user.provider = auth.provider
     user.uid = auth.uid
     user.name = auth.info.name
     user.oauth_token = auth.credentials.token
     user.oauth_expires_at = Time.at(auth.credentials.expires_at)
     user.email = auth.info.email
     # user.location = auth.info.user_hometown
     user.save!
   end
 end
end