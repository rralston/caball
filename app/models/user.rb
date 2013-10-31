class User < ActiveRecord::Base

  include ActionView::Helpers
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fb_token
  
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
  has_one :resume, :class_name => 'UploadedDocument', :as => :documentable, :dependent => :destroy
  has_one :cover_photo, :class_name =>'Photo' , :as => :imageable, :dependent => :destroy, :conditions => { :is_cover => true }
  
  has_one :demo_reel, :class_name => 'Video', :as => :videoable, :dependent => :destroy, :conditions => { :is_demo_reel => true }
  has_many :other_videos, :class_name => 'Video', :as => :videoable, :dependent => :destroy, :conditions => { :is_demo_reel => false }
  # this gives all videos incluing demo reel and other videos
  has_many :videos, :as => :videoable, :dependent => :destroy

  has_many :projects, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :talents, :dependent => :destroy
  has_many :friendships
  has_many :likes
  has_many :lovers, :class_name => 'Like', :as => :loveable

  has_many :read_activities

  has_one :agentship
  has_one :agent, :through => :agentship

  # friends are those whom this user is following.
  has_many :friends, through: :friendships

  # follows gives who ever is following the user
  has_many :follows, class_name: "Friendship", foreign_key: "friend_id"

  # followers are the users who follow this user
  has_many :followers, through: :follows, source: :user, foreign_key: "friend_id"

  # accepts_nested_attributes_for :profile, :reject_if => :all_blank
  has_many :comments, :dependent => :destroy
  
  has_many :blogs, :dependent => :destroy

  has_many :attends, :dependent => :destroy

  has_many :sent_endorsements, :class_name => 'Endorsement', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :received_endorsements, :class_name => 'Endorsement', :foreign_key => 'receiver_id', :dependent => :destroy


  accepts_nested_attributes_for :characteristics, :profile, :photos, :other_videos, :demo_reel,
                                :projects, :talents, :cover_photo, :resume,
                                :agentship, :allow_destroy => true

  has_many :role_applications, :dependent => :destroy
  has_many :applied_roles, :class_name => 'Role', :through => :role_applications, :source => :role
  has_many :all_applied_projects, :class_name => 'Project', :through => :applied_roles, :source => :project
  
  attr_accessible :name, :email, :location, :about, :profile_attributes,
                  :imdb_url, :characteristics_attributes, :photos_attributes,
                  :talents_attributes, :photo, :other_videos_attributes, :projects_attributes,
                  :admin, :gender, :headline, :featured, :expertise, :cover_photo_attributes,
                  :resume_attributes, :resume, :notification_check_time, :experience, :agent_name, :url_name,
                  :agent_present, :guild_present, :guild, :agentship_attributes, :demo_reel_attributes,
                  :terms_of_service, :provider, :uid, :managing_company

 # Name, Email is Required for User Sign-Up
  validates_presence_of :name, :email, :message => "is required"
  
  validates :terms_of_service, acceptance: true

  geocoded_by :location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  validates_with UserRolesValidator
  validates_with UserLocationValidator

  before_save :update_url_name

  def update_url_name
    if self.name_changed?

      new_name = truncate(self.name, :length => 20, :separator => ' ', :omission => '')

      # if the name is changed, convert to the url name
      self.url_name = new_name.gsub(/\s/,'-').gsub(/[^a-zA-Z0-9-]/, '').downcase

      if self.id.present?
        same_named_count = User.where("lower(url_name) like lower(?) and id <> ? ",  "#{self.url_name}%", self.id).size
      else
        # check  and get size of if any other users having the same url_name
        same_named_count = User.where("lower(url_name) like lower(?)", "#{self.url_name}%").size
      end



      if same_named_count > 0
        if self.id.present?
          # append the id after the url_name.
          self.url_name = self.url_name + "-#{self.id}"
        else
          total_entities = User.last.id rescue 0
          self.url_name = self.url_name + "-#{total_entities.to_i + 1}"
        end
      end

    end
  end

  scope :popular,
        select('users.*, count(friendships.id) AS fans_count').
        joins("inner join friendships on friendships.friend_id = users.id").
        group("users.id").
        order("fans_count DESC")

  scope :agents,
        select('users.*').
        joins("inner join talents on talents.user_id = users.id").
        where("talents.name = ? ", 'Agent')

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

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    ## debugger
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    # puts auth.inspect
    if user.nil?
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20].camelize + '_123',
                           fb_token: auth.credentials.token)
    else
      user.update_attributes(fb_token: auth.credentials.token)
    end
    user
  end

  def get_cover
    if (cover_photo.nil? || cover_photo.image.url == "/images/fallback/User_default.png") && !talents.empty?
      return "../assets/default_cover/#{talents.first.name}.jpg"
    elsif cover_photo.nil?
      return "/assets/default_cover/Fan.jpg"
    else
      return cover_photo.image.url(:original) rescue "/assets/default_cover/Fan.jpg"
    end
  end


  def get_cover_large
    if (cover_photo.nil? || cover_photo.image.url == "/images/fallback/User_default.png") && !talents.empty?
      return "../assets/default_cover/#{talents.first.name}.jpg"
    elsif cover_photo.nil?
      return "/assets/default_cover/Fan.jpg"
    else
      return cover_photo.image.url(:large) rescue "/assets/default_cover/Fan.jpg"
    end
  end

  def get_cover_regular
    if (cover_photo.nil? || cover_photo.image.url == "/images/fallback/User_default.png") && !talents.empty?
      return "../assets/default_cover/#{talents.first.name}.jpg"
    elsif cover_photo.nil?
      return "/assets/default_cover/Fan.jpg"
    else
      return cover_photo.image.url(:regular) rescue "/assets/default_cover/Fan.jpg"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.experience
    #Experience of the user in hash
    {
      '0-2 year(s)' => '0 - 2 years',
      '3-5 years'   => '3 - 5 years',
      '6-10 years'  => '6 - 10 years',
      '10+ years'   => '10+ years',
    }
  end

  def self.guilds
    #Experience of the user in hash
    {
      'SAG/AFTRA' => 'SAG/AFTRA',
      'IATSE'     => 'IATSE',
      'WGA'       => 'WGA',
      'DGA'       => 'DGA',
      'PGA'       => 'PGA',
      'Other'     => 'Other'
    }
  end

  def self.types
    {
      'Fan - Only select if your a just a film fan'      => 'Fan',
      'Agent'                                             => 'Agent',
      'Business - Manager, Studio Exec'                   => 'Business', 
      'Cast - Actor'                                      => 'Cast', 
      'Camera Dept.'                                      => 'Camera',
      'Light Dept.'                                       => 'Light',
      'Sound/Audio Dept.'                                 => 'Sound',
      'Directing'                                         => 'Directing',
      'Pre Production - Casting Director, Location'       => 'Pre-Production', 
      'Production - Producer, Assistant'                  => 'Production', 
      'Post-Pro - Editor, Effects'                        => 'Post-Pro', 
      'Set - Hair, Makeup, Construction'                  => 'Set', 
      'Writing Department - Screenwriter, Assistant etc.' => 'Writer',
      'Other'                                             => 'Other'
    }
  end

  def self.sub_types
    {
      'Cast'           => {
                            'Actor'   => 'Actor',
                            'Actress' => 'Actress',
                            'Stunt'   => 'Stunt',
                            'Dancer'  => 'Dancer',
                            'Driver'  => 'Driver',
                            'Voice'  => 'Voice'
                          },
      'Camera'          => {
                            'Director of Photography (DP)' => 'Director of Photography (DP)',
                            'Camera Operator'              => 'Camera Operator',
                            'Camera Assistant'             => 'Camera Assistant',
                            'B Camera Operator'            => 'B Camera Operator',
                            '2nd Unit Cinematographer.'    => '2nd Unit Cinematographer.',
                            'Additional Cinematography'    => 'Additional Cinematography',
                            'Still Photographer'           => 'Still Photographer',
                            'DIT (Digital Imaging Tech)'   => 'DIT (Digital Imaging Tech)',
                            'Steadicam operator'           => 'Steadicam operator',
                            'Underwater DP'                => 'Underwater DP'
                          },
      'Light'           => {
                            'Best Boy'    => 'Best Boy',
                            'Electrician' => 'Electrician',
                            'Gaffer'      => 'Gaffer',
                            'Grip'        => 'Grip',
                            'Key Grip'    => 'Key Grip'
                          },
      'Sound'            => {
                            'Composer'         => 'Composer',
                            'Sound Designer'   => 'Sound Designer',
                            'Sound Technician' => 'Sound Technician',
                            'Boom operators'   => 'Boom operators',
                            'Sound assistants' => 'Sound assistants',
                            'Dialogue editor'  => 'Dialogue editor',
                            'Dubbing mixer'    => 'Dubbing mixer',
                            'Foley artist'     => 'Foley artist',
                            'Foley editor'     => 'Foley editor',
                            'Production mixer' => 'Production mixer',
                            'Sound editor'     => 'Sound editor',
                            'Sound recordist'  => 'Sound recordist'
                          },
      'Set'            => {
                            "Make up artist"        => "Make up artist",
                            "Hairdresser"           => "Hairdresser",
                            "Costume"               => "Costume",
                            "Costume Assistant"     => "Costume Assistant",
                            "Prop builder"          => "Prop builder",
                            "Prop assistant"        => "Prop assistant",
                            "Set decorator/dresser" => "Set decorator/dresser",
                            "Script Supervisor"     => "Script Supervisor",
                          }, 
      'Production'     => {
                            "production assistant"              => "production assistant",
                            "Production Accountant/Asst"        => "Production Accountant/Asst",
                            "Producer"                          => "Producer",
                            "Production Supervisor/Coordinator" => "Production Supervisor/Coordinator",
                            "Exec. Producer"                    => "Exec. Producer",
                            "Line Producer"                     => "Line Producer"
                          }, 
      'Post-Pro'       => {
                            "Editor"                      => "Editor",
                            "Editor asst"                 => "Editor asst",
                            "Visual effects"              => "Visual effects",
                            "Graphic/Titles design"       => "Graphic/Titles design",
                            "Post- production Supervisor" => "Post- production Supervisor"
                          }, 
      'Business'       => {
                            "Manager"          => "Manager",
                            "Lawyer"           => "Lawyer",
                            "Studio Executive" => "Studio Executive",
                            "Investment"        => "Investment"
                          }, 
      'Writer'         => {
                            "Screenwriter"        => "Screenwriter",
                            "Script Consultant"   => "Script Consultant",
                            "Script Coordinators" => "Script Coordinators",
                            "Writers' Assistants" => "Writers' Assistants",
                            "Formatter/Proofer"   => "Formatter/Proofer"
                          }, 
      'Pre-Production' => {
                            "Location Scout"     => "Location Scout",
                            "Location Manager"   => "Location Manager",
                            "Location Assistant" => "Location Assistant",
                            "Casting Director"   => "Casting Director",
                            "Casting Assistant"  => "Casting Assistant"
                          }, 
      'Directing'       => {
                            "Director"       => "Director",
                            "Asst. Director" => "Asst. Director"
                          },
      'Agent'          => {},
      'Other'          => {
                            "Food/Catering"      => "Food/Catering",
                            "Acting Coach"       => "Acting Coach",
                            "Security"           => "Security",
                            "Medic"              => "Medic",
                            "Stunt coordinator"  => "Stunt coordinator",
                            "Pyrotechnics"       => "Pyrotechnics",
                            "Aerial photography" => "Aerial photography",
                            "Intern"             => "Intern",
                            "Personal Assistant" => "Personal Assistant",
                            "PR Executive"       => "PR Executive",
                            "Other"              => "Other"
                          }
    }
  end

  def self.super_sub_types
    {}
  end

  def self.types_costs
    # add the cost for each role 
    {
      'Actor / Actress'               => 0.10,
      'Animators'                     => 90,
      'Art'                           => 25,
      'Audio'                         => 67,
      'Casting Director'              => 67,
      'Cinematographer / DP'          => 67,
      'Composer'                      => 67,
      'Costumes'                      => 67,
      'Director'                      => 67,
      'Distribution Professional'     => 67,
      'Editor'                        => 67,
      'Executive Producer'            => 67,
      'Hairstylist / Makeup Artist'   => 67,
      'Lighting / Electrical'         => 67,
      'Other'                         => 67,
      'Personal Assistant'            => 67,
      'Producer'                      => 67,
      'Production Staff'              => 67,
      'Props'                         => 67,
      'Set Design'                    => 67,
      'Sound'                         => 67,
      'Stuntman'                      => 67,
      'Talent Agent / Literary Agent' => 67,
      'Talent Manager'                => 67,
      'Visual Effects'                => 67,
      'Writer'                        => 67
    }
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

  def profile_pic_large
    if profile.present? 
      profile.image.url(:large)
    elsif photos.present?
      photos.first.image.url(:large)
    else
      "/assets/actor.png"
    end
  end

  def profile_thumb
    if profile.present? 
      profile.image.url(:thumb)
    elsif photos.present?
      photos.first.image.url(:thumb)
    else
      "/assets/actor.png"
    end
  end

  def profile_medium
    if profile.present? 
      profile.image.url(:medium)
    elsif photos.present?
      photos.first.image.url(:medium)
    else
      "/assets/actor.png"
    end
  end

  def profile_tiny
    if profile.present? 
      profile.image.url(:tiny)
    elsif photos.present?
      photos.first.image.url(:tiny)
    else
      "/assets/actor.png"
    end
  end

  def details_complete?
    self.location.present?
  end

  def returning_user?
    # sign in count is 1 for new user
    sign_in_count > 1
  end

  def recommended_people
    # pick users with talents as the open roles in the projects owned by the current user
    # User.joins(:talents).
    #       where(:talents => {:name => roles_required}).
    #         where('user_id != ?', self.id).uniq
    
    # Users Close to your Location with The Highest numbers of Fans that you don't already follow. 
    User.near(self.location).select('users.*, count(friendships.id) AS fans_count').
    joins("left outer join friendships on friendships.friend_id = users.id").
    group("users.id").
    where("users.id NOT IN (?) ", self.friend_ids + [self.id] ).
    order("fans_count DESC")
  end

  def recommended_projects
    # pick all projects whose open roles match with the user's talent names
    Project.joins(:roles).
              where(:roles => {:name => talent_names, :filled => false}).
                where('project_id NOT IN (?)', self.project_ids).uniq
  end

  def recommended_events
    # as of now taking events near users location
    Event.near(self.location)
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
      where('(owner_id in (?) AND owner_type = ? AND recipient_id IS NULL) OR (recipient_id = ?)', self.friend_ids, 'User', self.id).
        where('activities.key NOT IN (?)', ['blog.update', 'comment.update'])
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
    # Projects.where('id in (?)' role_applications.roles.)
    # role_applications.map{ |application|
    #   application.role.project
    # }.uniq
    all_applied_projects.uniq
  end

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'profile_pic' => profile_pic,
      'profile_thumb' => profile_thumb,
      'profile_medium' => profile_medium,
      'profile_tiny' => profile_tiny,
      'cover_photo' => display_cover,
      'cover_regular' => get_cover_regular,
      'talent_names' => talent_names,
      'url_param' => url_param
    }
    hash.merge!(extra_hash)
  end

  def attending_events
    attends.includes(:attendable).where(:attendable_type => 'Event').map(&:attendable)
  end

  def self.popular_users
    User.popular
  end

  def self.recently_updated(page = nil, per_page = nil, current_user = nil)
    if current_user.present?
      User.where('id <> ?', current_user.id).order('updated_at DESC').per_page_kaminari(page).per(per_page)
    else
      User.order('updated_at DESC').per_page_kaminari(page).per(per_page)
    end

  end

  def followed_by_user?(user)
    followers.includes?(user)
  end

  def self.filter_all(users = nil, query = nil, location = nil, radius = 100,  talents = nil,  sub_talents = nil, cast_hash = nil, page = nil, per_page = nil, current_user = nil)

    users = User if users.nil?

    if query.present?
      users = users.where('lower(users.name) like lower(?)', "%#{query}%")
    end

    if location
      users = users.near(location, radius)
    end

    if !nil_hash?(cast_hash)
      cast_hash = delete_empty_values(cast_hash)

      cast_hash.each do |key, value|
        val = value.kind_of?(Array) ? value : [value]
        users = users.joins(:characteristics).where('characteristics.'+key.to_s+' in (?)', val)
      end

    end

    if talents and !talents.empty? and sub_talents.present? 
      
      talents = [talents] if !talents.kind_of?(Array)

      # if sub talents are also searched for 
      talents_with_sub_talents = sub_talents.keys

      talents_with_out_sub_talents = talents - talents_with_sub_talents

      if talents_with_out_sub_talents.present?
        
        query_string = "(talents.name IN #{talents_with_out_sub_talents.sql_array_for_in})"

        query_string = query_string + 'OR' + talents_with_sub_talents.collect { |super_talent|

          sub_talents[super_talent] = [sub_talents[super_talent]] if !sub_talents[super_talent].kind_of?(Array)
            
          "( talents.name = '#{super_talent}' AND talents.sub_talent in #{sub_talents[super_talent].sql_array_for_in} )"
        }.join(' OR ')

      else
        query_string = talents_with_sub_talents.collect { |super_talent|
          sub_talents[super_talent] = [sub_talents[super_talent]] if !sub_talents[super_talent].kind_of?(Array)

          "( talents.name = '#{super_talent}' AND talents.sub_talent in #{sub_talents[super_talent].sql_array_for_in} )"
        }.join(' OR ')

      end

      users = users.joins(:talents).where(query_string)
      
    elsif talents and !talents.empty?
      talents = [talents] if !talents.kind_of?(Array)
      users = users.joins(:talents).where('talents.name in (?)', talents).uniq

      #users = users.select{ |user|
      #  user_talents = user.talents.map(&:name).uniq
      #  (talents - user_talents).empty?
      #}
    end

    if current_user.present?
      users = users.where( 'users.id <> ?', current_user.id )
    end

    Kaminari.paginate_array(users).per_page_kaminari(page).per(per_page)
  end

  def self.delete_empty_values hash
    hash.each do |key,value|
      if !value.present?
        hash.delete(key)
      end
    end
    hash
  end

  def self.nil_hash? hash
    empty_flag = true
    hash.each do |key,value|
      if value.present?
        empty_flag = false
      end
    end
    empty_flag
  end

  def as_json(options = {})
    json = super(options)
    if options[:check_user].present?
      # tells if user is following the user
      json[:user_following] = self.followers.include?(options[:check_user])
    end

    if options[:for_search].present? and options[:for_search] == true
      json[:thumbnail] = profile_thumb
      json[:label] = name
      json[:value] = name
      json[:category]= 'People'
      json[:url] = "/users/#{id}"
    end
    json[:url_param]      = self.url_param
    json[:display_cover]  = self.display_cover
    json
  end

  def unread_notifications

    # comments on all projects user own
    project_comment_ids = Comment.where(:commentable_type => 'Project', :commentable_id => project_ids).where('user_id <> ?', self.id).pluck('comments.id')
    # comments on all events user own
    event_comment_ids = Comment.where(:commentable_type => 'Event', :commentable_id => event_ids).where('user_id <> ?', self.id).pluck('comments.id')

    # get the comment ids of all 
    comment_ids = project_comment_ids + event_comment_ids
    
    # get activities which belong to a comment among those comment ids.
    notifications = Activity.order("created_at DESC").
      where('created_at > ? AND trackable_type = ? AND trackable_id in (?)', self.notification_check_time, 'Comment', comment_ids)


    # mix notifications with receipts.
    notifications = notifications + self.receipts.includes(:message).where('created_at > ? and receipts.is_read = false', self.notification_check_time)

    notifications.sort_by(&:created_at).reverse  
  end

  def self.search_users(query)
    User.where('lower(name) like lower(?)', "%#{query}%")
  end

  # checks if the user can apply for the specified role.
  def can_apply_for?(role)
     self.has_applied?(role) == false and self.talents.map(&:name).include?(role.name)
  end

  # tells if user has already applied to this role.
  def has_applied?(role)
    self.role_applications.where(:role_id => role.id).present?
  end

  def valid_videos
    videos.where('provider IS NOT NULL')
  end

  def completeness

    check_array = ["location", "about", "gender", "headline", "expertise", "imdb_url", "resume",
      "profile", "photos", "cover_photo", "talents", "videos", "experience"]

    present_sum = check_array.map { |prop|
      if self.send(prop).present?
        if prop == 'photos'
          # photos size needs to be 3 in order to have 100% completeness
          self.send(prop).size >= 3 ? 1 : 0
        else
          1
        end
      else
        0
      end
    }.reduce(:+)

    if characteristics.present?
      present_sum = present_sum + characteristics.completeness_sum
    end

    total_props = check_array.size + 5 # plus 12 for characteristics size

    ((present_sum.to_f/total_props.to_f) * 100).to_i
  end

  def self.admin_emails
    User.where(:admin => true).map(&:email)
  end

  def self.featured_people
    #  TODO: Change this to true
    User.where(featured: true)
  end

  def display_cover
    get_cover
  end

  def url_param
    url_name.present? ? url_name : id
  end

  def reset_sub_talents
    talents.update_all(:sub_talent => nil, :super_sub_talent => nil)
  end

  def all_photos
    # this include other photos and profile photo also, used in the photos popup
    ([profile]+[photos]).flatten
  end

  def only_fan?
    talent_names.try(:first) == 'Fan'
  end



  # HEADS UP :  Use .count("DISTINCT projects.id") if you need count of these projects. if not it will give wrong value.
  def self_and_managing_projects
    # Projects the user created.
    # +
    # Role Application Approved (Since this incorporates Managers As Well)
    Project.
      joins( "LEFT OUTER JOIN roles ON roles.project_id = projects.id LEFT OUTER JOIN role_applications ON role_applications.role_id = roles.id LEFT OUTER JOIN users ON users.id = role_applications.user_id" ).
        where( " ( projects.user_id = ? ) OR ( role_applications.approved = true AND role_applications.user_id = ? )", self.id, self.id ).
          uniq
    # Projects for which the user has a approved role and has the manager flag set for the role application.
    # Project.
    #   joins( "LEFT OUTER JOIN roles ON roles.project_id = projects.id LEFT OUTER JOIN role_applications ON role_applications.role_id = roles.id LEFT OUTER JOIN users ON users.id = role_applications.user_id" ).
    #     where( " ( projects.user_id = ? ) OR ( role_applications.approved = true AND role_applications.manager = true AND role_applications.user_id = ? )", self.id, self.id ).
    #       uniq
  end

  def managing_projects
    # Projects for which the user has a approved role and has the manager flag set for the role application.
    Project.joins( :roles => { :applications => :user } ).
      where( "role_applications.approved = true AND role_applications.manager = true AND role_applications.user_id = ? ", self.id ).
        uniq
  end

end

class Array
  def sql_array_for_in
    self.to_s.gsub(/]/, ')').gsub(/\[/, '(').gsub(/"/,'\'')
  end
end