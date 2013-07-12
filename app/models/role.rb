class Role < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :description, :filled, :subrole

  has_many :applications, :class_name => 'RoleApplication', :dependent => :destroy  

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'project' => project
    }
    hash.merge!(extra_hash)
  end

end