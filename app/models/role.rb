class Role < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :description, :filled, :subrole

  has_many :applications, :class_name => 'RoleApplication', :dependent => :destroy  
end