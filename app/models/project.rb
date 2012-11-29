class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :description, :start, :end
  validates_presence_of :title, :description, :message => "is required"
end