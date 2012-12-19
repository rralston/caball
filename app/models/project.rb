class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :photos, :as => :imageable
  has_many :videos, :as => :videoable
  attr_accessible :title, :description, :start, :end, :roles_attributes, :photos_attributes, :videos_attributes
  accepts_nested_attributes_for :roles, :photos, :videos, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
end