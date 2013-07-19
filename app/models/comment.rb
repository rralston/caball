class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content, :user, :photo_attributes, :commentable_type, :commentable_id

  has_many :likes, :as => :loveable
  has_many :likers, :through => :likes, :source => :user
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  has_one :photo, :as => :imageable, :dependent => :destroy

  accepts_nested_attributes_for :photo

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'commentable' => commentable,
      'likes_count' => likes.count,
      'liker_ids' => likers.uniq.map(&:id),
      'photo' => photo.try(:image)
    }
    hash.merge!(extra_hash)
  end
end
