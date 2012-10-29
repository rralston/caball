class User < ActiveRecord::Base
  has_one :characteristics
  has_one :photo
  has_many :videos
  accepts_nested_attributes_for :characteristics, :photo, :videos, :allow_destroy => true
  attr_accessible :first_name, :last_name, :email, :location, :about, :characteristics_attributes, :photo_attributes, :photo, :videos_attributes
  validates_presence_of :first_name, :last_name, :email, :message => "is required"
end