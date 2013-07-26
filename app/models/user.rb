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
  has_many :photos, :as => :imageable, :dependent => :destroy, :conditions => { :is_cover => false }
  has_one :resume, :as => :documentable, :dependent => :destroy
  has_one :cover_photo, :class_name =>'Photo' , :as => :imageable, :dependent => :destroy, :conditions => { :is_cover => true }
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  has_many :friendships
  has_many :likes
  has_many :lovers, :class_name => 'Like', :as => :loveable

  # friends are those whom this user is following.
  has_many :friends, through: :friendships

  # follows gives who ever is following the user
  has_many :follows, class_name: "Friendship", foreign_key: "friend_id"

  # followers are the users who follow this user
  has_many :followers, through: :follows, source: :user, foreign_key: "friend_id"

  accepts_nested_attributes_for :profile, :reject_if => :all_blank
  has_many :comments
  has_many :blogs, :dependent => :destroy

  has_many :attends

  has_many :sent_endorsements, :class_name => 'Endorsement', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :received_endorsements, :class_name => 'Endorsement', :foreign_key => 'receiver_id', :dependent => :destroy


  accepts_nested_attributes_for :characteristics, :photos, :videos, :projects, :talents, :cover_photo, :resume, :allow_destroy => true



  has_many :role_applications, :dependent => :destroy
  attr_accessible :name, :email, :location, :about, :profile, :profile_attributes,
                  :imdb_url, :characteristics_attributes, :photos_attributes,
                  :talents_attributes, :photo, :videos_attributes, :projects_attributes,
                  :admin, :gender, :headline, :featured, :expertise, :cover_photo_attributes,
                  :resume_attributes

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

  def self.experience
    #Experience of the user in hash
    {
      '0-2 year(s)' => '0 to 2 year(s)',
      '3-5 years' => '3 to 5 years',
      '6-10 years' => '6 to 10 years',
      '10+ years' => 'above 10 years',
    }
  end

  def self.types
    # {
    #   'Actor' => 'Actor', 
    #   'Producer' => 'Producer', 
    #   'Director' => 'Director', 
    #   'Technical' => 'Technical', 
    #   'Stuntmen' => 'Stuntmen', 
    #   'Fan' => 'Fan', 
    #   'Talent Manager' => 'Talent Manager'
    # }
    {'Actor / Actress' => 'Actor / Actress', 'Animators' => 'Animators', 'Art' => 'Art', 'Audio' => 'Audio', 
    'Casting Director' => 'Casting Director', 'Cinematographer / DP' => 'Cinematographer / DP', 'Composer' => 'Composer', 
    'Costumes' => 'Costumes', 'Director' => 'Director', 'Distribution Professional' => 'Distribution Professional', 
    'Editor' => 'Editor', 'Executive Producer' => 'Executive Producer', 'Hairstylist / Makeup Artist' => 'Hairstylist / Makeup Artist', 
    'Lighting / Electrical' => 'Lighting / Electrical', 'Other' => 'Other', 'Personal Assistant' => 'Personal Assistant', 'Producer' => 'Producer', 
    'Production Staff' => 'Production Staff', 'Props' => 'Props', 'Set Design' => 'Set Design', 'Sound' => 'Sound',
    'Stuntman' => 'Stuntman', 'Talent Agent / Literary Agent' => 'Talent Agent / Literary Agent', 'Talent Manager' => 'Talent Manager', 
    'Visual Effects' => 'Visual Effects', 'Writer' => 'Writer'}
  end
  
  def profile_pic
    if profile.present? 
      profile.image.url(:medium)
    elsif photos.present?
      photos.first.image.url(:medium)
    else
      "/assets/actor.png"
    end
  end

  def details_complete?
    self.location.present?
  end

  def recommended_people
    # pick users with talents as the open roles in the projects owned by the current user
    User.joins(:talents).
          where(:talents => {:name => roles_required}).
            where('user_id != ?', self.id).uniq
  end

  def recommended_projects
    # pick all projects whose open roles match with the user's talent names
    Project.joins(:roles).
              where(:roles => {:name => talent_names, :filled => false}).
                where('project_id NOT IN (?)', self.project_ids).uniq
  end

  def roles_required
    # return array of all role names required.
    all_roles = self.projects.map{ |project|
      project.open_roles.map(&:name)
    }
    all_roles.flatten.uniq
  end

  def talent_names
    self.talents.map(&:name).uniq
  end

  def activities_feed
    Activity.order("created_at DESC").
      where('(owner_id in (?) AND owner_type = ? AND recipient_id IS NULL) OR (recipient_id = ?)', self.friend_ids, 'User', self.id)
  end

  def friends_activities
    Activity.order("created_at desc").
              where(:owner_id => self.friend_ids, :owner_type => 'User').
              where(:recipient_id => nil)
  end

  def addressed_activities
    Activity.order("created_at desc").
              where(:recipient_id => self.id)
  end

  def applied_projects
    role_applications.map{ |application|
      application.role.project
    }.uniq
  end

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'profile_pic' => profile_pic,
      'cover_photo' => cover_photo
    }
    hash.merge!(extra_hash)
  end

  def attending_events
    attends.where(:attendable_type => 'Event').map(&:attendable)
  end

end