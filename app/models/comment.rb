class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content

  has_many :likes, :as => :loveable
  belongs_to :user
  belongs_to :project

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'project' => project
    }
    hash.merge!(extra_hash)
  end
end
