class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :location, :user_about
  validates_presence_of :first_name, :last_name, :email, :message => "is required"
end