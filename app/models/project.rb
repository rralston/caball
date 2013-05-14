class Project < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  belongs_to :user
  has_many :roles, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  attr_accessible :title, :description, :start, :end, :featured, :roles_attributes, :photos_attributes, :videos_attributes, :status, :genre, :is_type, :thoughts, :compensation, :location
  accepts_nested_attributes_for :roles, :photos, :videos, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
end