class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content

  has_many :likes, :as => :loveable
  belongs_to :user
  belongs_to :project
end
