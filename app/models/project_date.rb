class ProjectDate < ActiveRecord::Base
  belongs_to :project

  attr_accessible :description, :date_time
end