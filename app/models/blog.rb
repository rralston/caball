class Blog < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: :destroy, owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content

  has_many :likes, :as => :loveable
  belongs_to :user
end
