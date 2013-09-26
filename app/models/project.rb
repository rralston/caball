class Project < ActiveRecord::Base
  include PublicActivity::Model
  include ActionView::Helpers
  
  tracked owner: ->(controller, model) { controller && controller.current_user }

  acts_as_taggable_on :genre, :is_type

  belongs_to :user
  has_many :likes, :as => :loveable, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  has_many :applications, :through => :roles
  has_many :fans, :through => :likes, :source => :user
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :project_dates, :class_name => 'ImportantDate', :as => :important_dateable, :dependent => :destroy


  attr_accessible :title, :description, :start, :end, :featured, :roles_attributes,
                  :photos_attributes, :videos_attributes, :status, :genre, :is_type, :genre_list, :is_type_list,
                  :thoughts, :compensation, :location, :headline, :project_dates_attributes, :union, :url_name, :union_present
  
  accepts_nested_attributes_for :roles, :photos, :videos, :project_dates, :genre, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
  validates :headline, :length => { :maximum => 300 }
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  
  before_save :update_url_name

  def update_url_name
    if self.title_changed?

      new_title = truncate(self.title, :length => 20, :separator => ' ', :omission => '')
      # if the name is changed, convert to the url name
      self.url_name = new_title.gsub(/\s/,'-').gsub(/\./,'').downcase
      
      # check  and get size of if any other projects having the same url_name
      same_named_count = Project.where("lower(url_name) like lower(?)", "#{self.url_name}%").size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        self.url_name = self.url_name + "-#{same_named_count.to_i + 1}"
      end
    end
  end


  scope :popular,
    select('projects.*, count(likes.id) AS fans_count').
    joins("inner join likes on likes.loveable_id = projects.id AND likes.loveable_type = 'Project' ").
    group("projects.id").
    order("fans_count DESC")

  def approved_user_applications
    applications.where(approved: true).map { |application| application.user }
  end

  def display_photo
    if photos.present? 
      photos.first.image.url(:original) 
    else
      # TODO: Change this to default project image.
      "/assets/actor.png"
    end
  end

  def display_medium
    if photos.present? 
      photos.first.image.url(:medium) 
    else
      # TODO: Change this to default project image.
      "/assets/actor.png"
    end
  end

  def display_large
    if photos.present? 
      photos.first.image.url(:large) 
    else
      # TODO: Change this to default project image.
      "/assets/actor.png"
    end
  end

  def display_regular
    if photos.present? 
      photos.first.image.url(:regular) 
    else
      # TODO: Change this to default project image.
      "/assets/actor.png"
    end
  end

  def display_thumb
    if photos.present? 
      photos.first.image.url(:thumb) 
    else
      # TODO: Change this to default project image.
      "/assets/actor.png"
    end
  end


  def roles_percent
    if roles.size > 0
      ((filled_roles.size.to_f / roles.size.to_f) * 10).to_i
    else
      10
    end
  end
  
  def open_roles
    # returns all open roles
    roles.select{ |role| !role.filled }
  end

  def filled_roles
    roles.select{ |role| role.filled }
  end

  def self.genres
    { 'Action' => 'Action', 'Adventure' => 'Adventure', 'Animation' => 'Animation', 'Biography' => 'Biography',
    'Comedy' => 'Comedy', 'Crime' => 'Crime', 'Documentary' => 'Documentary', 'Drama' => 'Drama', 'Family' => 'Family',
    'Fantasy' => 'Fantasy', 'Film-Noir' => 'Film-Noir', 'History' => 'History', 'Horror' => 'Horror', 'Musical' => 'Musical',
    'Mystery' => 'Mystery', 'Romance' => 'Romance', 'Scifi' => 'Scifi', 'Sports' => 'Sports', 'Thriller' => 'Thriller',
    'War' => 'War', 'Western' => 'Western' }
  end

  def self.types
    {'Feature Length' => 'Feature Length', 'Music Video' => 'Music Video', 'Reality' => 'Reality', 'Short' => 'Short',
    'TV Series' => 'TV Series', 'Webisode' => 'Webisode'}
  end

  def self.status_stages
    { 'Draft' => 'Draft', 'Development' => 'Development', 'Pre-Production' => 'Pre-Production', 'Production' => 'Production', 'Post-Production' => 'Post-Production', 'Completed' => 'Completed'}
  end

  def self.compensation_stages
    {'Paid' => 'Paid', 'Low-Paid' => 'Low-Paid', 'Copy / Credit' => 'Copy / Credit'}
  end

  def self.unions
    {
      'Non-union' => 'Non-union',
      'SAG-AFTRA' => 'SAG-AFTRA',
      'WGA'       => 'WGA',
      'IATSE'     => 'IATSE',
      'PGA'       => 'PGA',
      'DGA'       => 'DGA',
      'Other'     => 'Other'
    }
  end

  def self.guilds
    unions
  end

  def roles_json
    super_roles = self.roles.group_by(&:name)
    roles_to_return = Hash.new

    super_roles.keys.each do |super_role|
      sub_roles = super_roles[super_role]
      roles_to_return[super_role] = {
        :subroles => sub_roles,
        :open_count => sub_roles.find_all{ |role| role.filled == false }.size,
        :filled_count => sub_roles.find_all{ |role| role.filled == true }.size,
        :total_count => sub_roles.size
      }
    end

    roles_to_return
  end

  def liker_ids
    fans.map(&:id)
  end

  def roles_for_dashboard
    super_roles = self.roles.group_by(&:name)
    roles_to_return = []
    super_roles.keys.each_with_index do |super_role, index|
      # sub_roles = roles.where(:name => super_role)
      sub_roles = super_roles[super_role]
      roles_to_return << {
        :id => index,
        :name => super_role,
        :subroles_json => sub_roles.to_json(:include => {
                                          :applications => {
                                            :include => {
                                              :user => {
                                                :methods => [
                                                  :talent_names
                                                ],
                                                :include => [
                                                  :followers,
                                                  :resume
                                                ]
                                              }
                                            }
                                          }
                                        }),
        :open_count => sub_roles.find_all{ |role| role.filled == false }.size,
        :filled_count => sub_roles.find_all{ |role| role.filled == true }.size,
        :total_count => sub_roles.size
      }
    end
    roles_to_return
  end

  def participant_mails
    applications.map(&:user).map(&:email).join(', ')
  end

  def selected_applicants_mails
    applications.joins(:user).where("role_applications.approved  = true").pluck('users.email').uniq
  end

  def non_selected_applicants_mails
    applications.joins(:user).where("role_applications.approved  = false").pluck('users.email').uniq
  end

  def pending_applications
    applications.where(:role_applications => { :approved => false }, :roles => { :filled => false })
  end

  def self.projects_by_followers(user)
    Project.where('projects.user_id in (?)', user.followers.pluck('friendships.user_id'))
  end

  def self.projects_by_friends(user)
    Project.where('projects.user_id in (?)', user.friends.pluck('friendships.friend_id'))
  end

  def self.featured_projects
    Project.where(:featured => true)
  end

  def self.popular_projects
    Project.popular
  end

  def self.recently_launched
    Project.where('status <> ?', 'Draft').order('created_at DESC')
  end

  def self.recent_projects(page = nil, per_page = 10)
    Kaminari.paginate_array(recently_launched).per_page_kaminari(page).per(per_page)
  end

  def self.order_by_new(projects)
    projects.sort_by(&:created_at)
  end

  def self.order_by_popularity(projects)
    projects.sort_by{ |project|
      project.fans.size
    }.reverse
  end

  def self.order_by_featured(projects)
    projects.sort_by{ |project|
      project.featured ? 0 : 1
    }
  end

  def self.sample_featured_projects
    Project.where(:featured => true)
    # featured_projects.first(10)
  end

  def self.sample_popular_projects
    popular_projects.where('status <> ?', 'Draft').first(3)
  end

  def super_roles_needed
    roles.map(&:name).uniq
  end


  def self.search_all(projects, query, roles, sub_roles, cast_hash, genres, types, location, radius, order_by, page, per_page = nil)

    projects = Project.where('status <> ?', 'Draft') if (projects.nil? || projects.empty?)

    if query.present?
      projects = projects.where('lower(projects.title) like lower(?)', "%#{query}%")
    end

    query_string = ''

    if roles.present? and sub_roles.present?
      roles = [roles].flatten

      roles_with_sub_talents = sub_roles.keys

      roles_with_out_sub_talents = roles - roles_with_sub_talents

      # this needs to be handled in the cash_hash check loop
      roles = roles_with_out_sub_talents

      if cast_hash.present?
        # cast role is handled in cast_hash check loop
        roles_with_out_sub_talents = roles_with_out_sub_talents - ['Cast']
      end 

      if roles_with_out_sub_talents.present?
        query_string = "( roles.name in #{roles_with_out_sub_talents.sql_array_for_in} ) OR "
      end

      query_string = query_string + roles_with_sub_talents.collect { |super_role|
        sub_roles[super_role] = [sub_roles[super_role]] if !sub_roles[super_role].kind_of?(Array)

        "( roles.name = '#{super_role}' AND roles.subrole in #{sub_roles[super_role].sql_array_for_in} )"

      }.join(' OR ')

      # projects = projects.joins(:roles).where(query_string).uniq

    elsif roles.present? and !cast_hash.present?
      roles = [roles].flatten

      query_string = "( roles.name IN #{roles.sql_array_for_in} )"

      # projects = projects.joins(:roles).where(:roles => {:name => roles}).uniq
    end

    # this will run every time when cast hash is present
    if cast_hash.present?
      roles = [roles].flatten

      # search for those projects containing roles in all other than Cast
      # and then search for projects containing role as cast and the cast hash params
      roles = roles - ['Cast']

      if query_string.present?
        query_string = query_string + " OR "
      end

      if roles.present?
        query_string = query_string + "( roles.name IN #{roles.sql_array_for_in} ) OR "
      end

      # example = if searched for  height => ['tall', 'short'], ethnicity => ['Asian', 'East Indian']
      # the following logic will search for the projects having (height as either of ['tall', 'short']) AND (ethnicity as either of ['Asian', 'East Indian'])
      query_string = query_string + cast_hash.collect { |key, value|
        val = value.kind_of?(Array) ? value : [value]
        "( roles.#{key.to_s} IN #{val.sql_array_for_in} )"
      }.join(' AND ')

    end

    # if above two if loops execute, they generate a query string.
    if query_string.present?
      projects = projects.joins(:roles).where(query_string).uniq

      # debugger
    end

    if genres.present?
      # if in case genres is a string tis would help to convert it to array
      # or if it is array, it will flatten.
      genres = [genres].flatten
      projects = projects.tagged_with(genres, :on => :genre)
    end

    if types.present?
      types = [types].flatten
      projects = projects.tagged_with(types, :on => :is_type)
    end

    if location.present?
      radius = 100 if radius.nil?
      projects = projects.near(location, radius)
    end

    if order_by.present?
      case order_by
      when 'recent'
        projects = projects.order('created_at DESC')
      when 'featured'
        projects = projects.order('featured DESC')
      when 'popular'
        projects =  projects.joins("left outer join likes on likes.loveable_id = projects.id AND likes.loveable_type = 'Project' ").
                    group("projects.id").
                    select('projects.*, count(likes.id) AS likes_count').
                    order("count(likes.id) DESC")
      end
    end



    Kaminari.paginate_array( projects ).per_page_kaminari(page).per(per_page)
  end

  def self.tested
    projects = Project.where('projects.id > 0')
    projects.joins("left outer join likes on likes.loveable_id = projects.id AND likes.loveable_type = 'Project' ").
                    group("projects.id").
                    select('projects.*, count(likes.id) AS likes_count').
                    order("count(likes.id) DESC")
  end

  def as_json(options = {})
    json = super(options)
    if options[:check_user].present?
      # tells if the user is following particular project
      json[:user_following] = self.liker_ids.include?(options[:check_user].id)
      json[:user_liked] = json[:user_following]
    end
    if options[:votes_data_for_user].present?
      user = options[:votes_data_for_user]
      json[:voted_by_user] = voted_by_user?(user)
      json[:voted_type_by_user] = voted_type_by_user(user)
    end

    if options[:for_search].present? and options[:for_search] == true
      json[:thumbnail] = display_thumb
      json[:label] = title
      json[:value] = title
      json[:category]= 'Projects'
      json[:url] = "/projects/#{id}"
    end
    json[:url_param] = url_param
    json[:display_photo] = display_photo
    json[:display_medium] = display_medium
    json[:display_regular] = display_regular
    json
  end

  def self.custom_json(projects, user = nil)
    projects.to_json(:include => [
                        :fans,
                        :photos,
                        :user,
                        :comments
                      ],
                      :methods => [
                        :super_roles_needed,
                        :roles_percent,
                        :open_roles,
                        :liker_ids,
                        :display_photo
                      ],
                      :check_user => user
                    )
  end

  def similar_events
    Event.near(location) + self.user.events
  end

  def similar_projects
    self.nearbys
  end

  def display_photo_big
    if photos.present? 
      photos.first.image.url
    else
      "/assets/actor.png"
    end
  end

  def self.search_projects(query)
    Project.where('lower(title) like lower(?) or lower(description) like lower(?)', "%#{query}%", "%#{query}%")
  end

  def valid_videos
    videos.where('provider IS NOT NULL')
  end

  def display_dates
    project_dates.order("important_dates.date_time ASC")
  end

  def self.role_types
    {
      'Agent'                                             => 'Agent',
      'Business - Manager, Studio Exec'                   => 'Business', 
      'Cast - Actor'                                      => 'Cast', 
      'Camera Dept.'                                      => 'Camera',
      'Light Dept.'                                       => 'Light',
      'Sound/Audio Dept.'                                 => 'Sound',
      'Directing'                                         => 'Director',
      'Pre Production - Casting Director, Location'       => 'Pre Production', 
      'Production - Producer, Assistant'                  => 'Production', 
      'Post-Pro - Editor, Effects'                        => 'Post-Pro', 
      'Set - Hair, Makeup, Construction'                  => 'Set', 
      'Writing Department - Screenwriter, Assistant etc.' => 'Writer',
      'Other'                                             => 'Other'
    }
  end

  def self.role_sub_types
    {
      'Cast'           => {
                            "Background"       => "Background",
                            "Co star"          => "Co star",
                            "Dancer"           => "Dancer",
                            "Feature"          => "Feature",
                            "Guest-star"       => "Guest-star",
                            "Lead"             => "Lead",
                            "Other"            => "Other",
                            "Principal"        => "Principal",
                            "Precision driver" => "Precision driver",
                            "special"          => "special",
                            "stand-in"         => "stand-in",
                            "stunt"            => "stunt",
                            "supporting"       => "supporting",
                            "double"           => "double",
                            "Voice over"       => "Voice over",
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
                            'Voiceover'        => 'Voiceover'
                          },
      'Crew'           => {
                            'Camera' => 'Camera',
                            'Light'  => 'Light',
                            'Sound'  => 'Sound'
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
                            "Talent Agent"     => "Talent Agent",
                            "Manager"          => "Manager",
                            "Lawyer"           => "Lawyer",
                            "Studio Executive" => "Studio Executive"
                          }, 
      'Writer'         => {
                            "Screenwriter"        => "Screenwriter",
                            "Script Consultant"   => "Script Consultant",
                            "Script Coordinators" => "Script Coordinators",
                            "Writers' Assistants" => "Writers' Assistants",
                            "Formatter/Proofer"   => "Formatter/Proofer"
                          }, 
      'Pre Production' => {
                            "Location Scout"     => "Location Scout",
                            "Location Manager"   => "Location Manager",
                            "Location Assistant" => "Location Assistant",
                            "Casting Director"   => "Casting Director",
                            "Casting Assistant"  => "Casting Assistant"
                          }, 
      'Director'       => {
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

  def self.role_super_sub_types
    { }
  end

  def url_param
    url_name.present? ? url_name : id
  end

end

class Array
  def sql_array_for_in
    self.to_s.gsub(/]/, ')').gsub(/\[/, '(').gsub(/"/,'\'')
  end
end