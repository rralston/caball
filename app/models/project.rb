class Project < ActiveRecord::Base
  include PublicActivity::Model
  tracked
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
                  :photos_attributes, :videos_attributes, :status, :genre, :is_type,
                  :thoughts, :compensation, :location, :headline, :project_dates_attributes, :union
  accepts_nested_attributes_for :roles, :photos, :videos, :project_dates, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
  validates :headline, :length => { :maximum => 300 }
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  
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
    user.followers.map(&:projects).flatten
  end

  def self.projects_by_friends(user)
    user.friends.map(&:projects).flatten
  end

  def self.featured_projects
    Project.where(:featured => true)
  end

  # TODO: Change this method to return popular projects
  def self.popular_projects
    Project.where(:featured => true)
  end

  def self.recently_launched
    Project.order('created_at DESC')
  end

  def self.recent_projects(page = nil, per_page = 10)
    if page.nil?
      recently_launched
    else
      Kaminari.paginate_array(recently_launched).page(page).per(per_page)
    end
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

  # TODO: Can try to optimize this
  def self.search_with_roles(roles, page=nil, per_page = nil)
    roles = [roles] if roles.class.name != 'Array'
    
    @projects_with_roles ||= Project.joins(:roles).includes(:roles).where(:roles => { :name => roles }).uniq
    
    @result_projects_by_roles ||= @projects_with_roles.select{ |project|
      project_roles = project.roles.map(&:name).uniq
      (roles - project_roles).empty?
    }

    Kaminari.paginate_array(@result_projects_by_roles).page(page).per(1)

  end

  def self.search_with_genres(genres)
    projects = Project.joins(:roles).includes(:roles).where(:roles => { :name => roles }).uniq
    result_projects = projects.select{ |project|
      project_roles = project.roles.map(&:name).uniq
      (roles - project_roles).empty?
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

  def self.in_location(query)
    Project.near(query)
  end

  def self.with_keyword(word)
    Project.where("title like ?", "%#{word}%")
  end

  def self.search_all(query)
    result = Project.in_location(query) + Project.with_keyword(query)
    result
  end

  def self.search_types(types)
    query = type.join('%')
    Project.where('type like ?', "%#{query}%")
  end

  def self.search_types(genres)
    query = genre.join('%')
    Project.where('genre like ?', "%#{query}%")
  end

  def self.search_all_with_pagination(query, roles, tags, types, page, per_page = nil)
    
    @projects ||= do_it
    def do_it
      projects = Project.search_all(query)
      projects = projects & Project.search_roles(roles) if roles.present?
      projects = projects & Project.search_types(types) if types.present?
      projects = projects & Project.search_genres(genres) if genres.present?

    end 

    Kaminari.paginate_array( projects ).page(page).per(per_page)
  end


  def self.custom_json(projects)
    projects.to_json(:include => [
                        :fans,
                        :photos,
                        :user
                      ],
                      :methods => [
                        :super_roles_needed,
                        :roles_percent,
                        :open_roles
                      ]
                    )
  end

  def similar_events
    Event.near(location).first(3)
  end

  def similar_projects
    self.nearbys.first(4)
  end

  def display_photo
    photos.first
  end

end