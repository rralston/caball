class Blog < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: :destroy, owner: ->(controller, model) { controller && controller.current_user }
  attr_accessible :content, :user, :photo_attributes, :video_attributes, :url_attributes

  has_many :likes, :as => :loveable
  has_many :likers, :through => :likes, :source => :user
  belongs_to :user

  has_one :photo, :as => :imageable, :dependent => :destroy
  has_one :video, :as => :videoable, :dependent => :destroy
  has_one :url, :as => :urlable, :dependent => :destroy

  accepts_nested_attributes_for :photo, :video, :url

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'likes_count' => likes.count,
      'liker_ids' => likers.uniq.map(&:id),
      'photo' => photo.try(:image),
      'video' => video,
      'url' => url
    }
    hash.merge!(extra_hash)
  end

  def as_json(options = {})
    json = super(options)
    if options[:check_user].present?
      # tells if the user is attending particular event.
      json[:user_following] = likers.uniq.map(&:id).include?(options[:check_user].id)
      json[:can_edit] = self.user == options[:check_user]
    end
    json
  end
end
