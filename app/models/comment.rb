class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content, :user

  has_many :likes, :as => :loveable
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'commentable' => commentable
    }
    hash.merge!(extra_hash)
  end
end
