class Project < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  belongs_to :user
  has_many :roles, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  attr_accessible :title, :description, :start, :end, :featured, :roles_attributes, :photos_attributes, :videos_attributes, :status, :genre, :is_type, :thoughts, :compensation, :location
  accepts_nested_attributes_for :roles, :photos, :videos, :allow_destroy => true  
  validates_presence_of :title, :description, :message => "is required"
  
  def roles_percent
    total_roles = roles.length
    filled_roles = 0
    roles.each do |role|
      if role.filled
        filled_roles += 1
      end
    end
    if total_roles == 0
      return 10
    else
      return ((filled_roles.to_f / total_roles.to_f) * 10).to_i
    end
  end
  
  def open_roles
    open_roles = 0
    roles.each do |role|
      if !role.filled
        open_roles += 1
      end
    end
    return open_roles
  end
end