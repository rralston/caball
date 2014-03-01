class RoleApplication < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  
  belongs_to :role
  belongs_to :user

  #attr_accessible :role_id, :user_id, :message, :approved, :manager

  has_one :project, :through => :role

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'role' => role
    }
    hash.merge!(extra_hash)
  end
  
end