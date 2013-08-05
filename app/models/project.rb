class Project < ActiveRecord::Base
  include PublicActivity::Model
  tracked

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
                  :thoughts, :compensation, :location, :headline, :project_dates_attributes, :union
  
  accepts_nested_attributes_for :roles, :photos, :videos, :project_dates, :genre, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
  validates :headline, :length => { :maximum => 300 }
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  
  scope :popular,
    select('projects.*, count(likes.id) AS fans_count').
    joins("inner join likes on likes.loveable_id = projects.id AND likes.loveable_type = 'Project' ").
    group("projects.id").
    order("fans_count DESC")


  def display_photo
    if photos.present? 
      photos.first.image.url(:medium) 
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
    { 'Draft' => 'Draft', 'Pre-Production' => 'Pre-Production', 'Greenlight' => 'Greenlight', 'Post-Production' => 'Post-Production', 'Completed' => 'Completed'}
  end

  def self.compensation_stages
    {'Paid' => 'Paid', 'Low-Paid' => 'Low-Paid', 'Copy / Credit' => 'Copy / Credit'}
  end

  def self.unions
    {'Union' => 'Union', 'Non-union' => 'Non-union'}
  end

  def roles_json

    super_roles = self.roles.group_by(&:name).keys
    roles_to_return = Hash.new

    super_roles.each do |super_role|
      sub_roles = roles.where(:name => super_role)
      roles_to_return[super_role] = {
        :subroles => sub_roles,
        :open_count => sub_roles.where(:filled => false).count,
        :filled_count => sub_roles.where(:filled => true).count,
        :total_count => sub_roles.where(:name => super_role).count
      }
    end

    roles_to_return
  end

  def liker_ids
    fans.map(&:id)
  end

  def roles_for_dashboard
    super_roles = self.roles.group_by(&:name).keys
    roles_to_return = []

    super_roles.each_with_index do |super_role, index|
      sub_roles = roles.where(:name => super_role)
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
                                                  :lovers,
                                                  :resume
                                                ]
                                              }
                                            }
                                          }
                                        }),
        :open_count => sub_roles.where(:filled => false).count,
        :filled_count => sub_roles.where(:filled => true).count,
        :total_count => sub_roles.where(:name => super_role).count
      }
    end
    roles_to_return
  end

  def participant_mails
    applications.map(&:user).map(&:email).join(', ')
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
    Project.order('created_at DESC')
  end

  def self.recent_projects(page = nil, per_page = 10)
    Kaminari.paginate_array(recently_launched).page(page).per(per_page)
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
    featured_projects.first(4)
  end

  def self.sample_popular_projects
    popular_projects.first(4)
  end

  def super_roles_needed
    roles.map(&:name).uniq
  end


  def self.search_types(types)
    query = type.join('%')
    Project.where('type like ?', "%#{query}%")
  end

  def self.search_types(genres)
    query = genre.join('%')
    Project.where('genre like ?', "%#{query}%")
  end

  def self.search_all(projects, query, roles, genres, types, location, radius, page, per_page = nil)

    projects = Project if (projects.nil? || projects.empty?)

    if query.present?
      projects = projects.where('projects.title like ?', "%#{query}%")
    end

    if roles.present?
      roles = [roles].flatten
      projects = projects.joins(:roles).where(:roles => {:name => roles}).group('projects.id').having("COUNT(DISTINCT roles.name) = #{roles.size}")
    end

    if genres.present?
      # if in case genres is a string tis would help to convert it to array
      # or if it is array, it wil flatten.
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


    Kaminari.paginate_array( projects ).page(page).per(per_page)
  end

  def as_json(options = {})
    json = super(options)
    if options[:check_user].present?
      # tells if the user is following particular project
      json[:user_following] = self.liker_ids.include?(options[:check_user].id)
    end

    if options[:votes_data_for_user].present?
      user = options[:votes_data_for_user]
      json[:voted_by_user] = voted_by_user?(user)
      json[:voted_type_by_user] = voted_type_by_user(user)
    end
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
    Event.near(location).first(3)
  end

  def similar_projects
    self.nearbys.first(4)
  end

  def display_photo_big
    if photos.present? 
      photos.first.image.url
    else
      "/assets/actor.png"
    end
  end

end