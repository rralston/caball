class User < ActiveRecord::Base
  has_one :characteristics
  has_one :photo
  accepts_nested_attributes_for :characteristics, :photo, :allow_destroy => true
  attr_accessible :first_name, :last_name, :email, :location, :about, :characteristics_attributes, :photo_attributes, :photo
  validates_presence_of :first_name, :last_name, :email, :message => "is required"
end