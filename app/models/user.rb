class User < ActiveRecord::Base
  has_one :characteristics, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  accepts_nested_attributes_for :characteristics, :photos, :videos, :projects, :talents, :allow_destroy => true
  attr_accessible :name, :email, :location, :about, :characteristics_attributes, :photos_attributes, :talents_attributes, :photo, :videos_attributes, :projects_attributes, :admin
  validates_presence_of :name, :email, :message => "is required"
  
  acts_as_messageable
  
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