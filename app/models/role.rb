class Role < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :description, :filled, :subrole
end