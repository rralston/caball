class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  attr_accessible :title, :description, :start, :end, :roles_attributes
  accepts_nested_attributes_for :roles, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
end