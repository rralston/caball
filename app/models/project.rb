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
                                                  :lovers
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

  def pending_applications
    applications.where(:role_applications => { :approved => false }, :roles => { :filled => false })
  end

end