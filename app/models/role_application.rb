class RoleApplication < ActiveRecord::Base
  belongs_to :role
  belongs_to :user

  has_one :project, :through => :role
end