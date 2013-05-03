class Blog < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content

  belongs_to :user
end
