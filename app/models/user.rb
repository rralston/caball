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

  after_create do |user|
    UserMailer.signup_confirmation(user).deliver
  end
  
  has_one :characteristics, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  has_many :friendships
  has_many :likes
  has_many :lovers, :class_name => 'Like', :as => :loveable
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship"
  has_many :inverse_friends, through: :inverse_friendships, source: :user, foreign_key: "friend_id"
  accepts_nested_attributes_for :profile, :reject_if => :all_blank
  has_many :comments
  has_many :blogs, :dependent => :destroy
  accepts_nested_attributes_for :characteristics, :photos, :videos, :projects, :talents, :allow_destroy => true
  attr_accessible :name, :email, :location, :about, :profile, :profile_attributes, :imdb_url, :characteristics_attributes, :photos_attributes, :talents_attributes, :photo, :videos_attributes, :projects_attributes, :admin, :gender, :headline, :featured
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

  def self.types
    {
      'Actor' => 'Actor', 
      'Producer' => 'Producer', 
      'Director' => 'Director', 
      'Technical' => 'Technical', 
      'Stuntmen' => 'Stuntmen', 
      'Fan' => 'Fan', 
      'Talent Manager' => 'Talent Manager'
    }
  end
  
  def profile_pic
    profile.image.url(:medium) rescue "/assets/actor.png"
  end

  def details_complete?
    self.location.present?
  end
end