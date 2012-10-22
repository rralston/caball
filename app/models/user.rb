class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :location, :user_about
end