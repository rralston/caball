class User < ActiveRecord::Base
  
  include Mailboxer::Models::Messageable
  acts_as_messageable
  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return email
    #if false
    #return nil
  end
  
  has_one :characteristics, :dependent => :destroy
  has_one :profiles, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  has_many :friendships
  has_many :likes
  has_many :friends, through: :friendships
  accepts_nested_attributes_for :profiles, :reject_if => :all_blank
  has_many :comments
  has_many :blogs, :dependent => :destroy
  accepts_nested_attributes_for :characteristics, :photos, :videos, :projects, :talents, :allow_destroy => true
  attr_accessible :name, :email, :location, :about, :profiles, :profiles_attributes, :imdb_url, :characteristics_attributes, :photos_attributes, :talents_attributes, :photo, :videos_attributes, :projects_attributes, :admin, :gender, :headline, :featured
  validates_presence_of :name, :email, :message => "is required"
    
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
    def profile_pic
    profiles.image.url(:medium) rescue "/assets/actor.png"
   end
end