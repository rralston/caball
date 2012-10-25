class User < ActiveRecord::Base
  has_one :characteristics
  accepts_nested_attributes_for :characteristics
  attr_accessible :first_name, :last_name, :email, :location, :about, :characteristics_attributes
  validates_presence_of :first_name, :last_name, :email, :message => "is required"
end