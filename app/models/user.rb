class User < ActiveRecord::Base
  has_one :characteristics
  has_one :photo
  has_many :videos
  accepts_nested_attributes_for :characteristics, :photo, :videos, :allow_destroy => true
  attr_accessible :name, :email, :location, :about, :characteristics_attributes, :photo_attributes, :photo, :videos_attributes
  validates_presence_of :name, :email, :message => "is required"
  
  acts_as_messageable
  def name
    email
  end
  
  def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
     user.provider = auth.provider
     user.uid = auth.uid
     user.name = auth.info.name
     user.oauth_token = auth.credentials.token
     user.oauth_expires_at = Time.at(auth.credentials.expires_at)
     user.email = auth.info.email
     user.save!
   end
 end
end