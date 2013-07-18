class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content, :user

  has_many :likes, :as => :loveable
  has_many :likers, :through => :likes, :source => :user
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'commentable' => commentable,
      'likes_count' => likes.count,
      'liker_ids' => likers.uniq.map(&:id)
    }
    hash.merge!(extra_hash)
  end
end
