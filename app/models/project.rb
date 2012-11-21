class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :description, :start, :end
end