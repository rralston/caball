class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :description, :start, :end
end