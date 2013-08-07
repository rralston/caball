class Event < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  acts_as_taggable

  belongs_to :user

  has_many :likes, :as => :loveable, :dependent => :destroy
  has_many :fans, :through => :likes, :source => :user
  has_one :main_photo, :class_name => 'Photo', :as => :imageable, :dependent => :destroy, :conditions => { :is_main => true }
  
  has_many :other_photos, :class_name => 'Photo', :as => :imageable,
           :dependent => :destroy, :conditions => { :is_main => false }
  
  has_many :votes, :as => :votable, :dependent => :destroy

  has_many :up_votes, :class_name => 'Vote', :as => :votable, :dependent => :destroy,
            :conditions => { :is_up_vote => true }

  has_many :down_votes, :class_name => 'Vote', :as => :votable, :dependent => :destroy,
            :conditions => { :is_down_vote => true }

  has_many :videos, :as => :videoable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  has_many :other_important_dates, :class_name => 'ImportantDate',
           :as => :important_dateable, :dependent => :destroy, :conditions => { :is_start_date => false, :is_end_date => false }

  has_many :likers, :through => :likes, :source => :user

  has_one :start, :class_name => 'ImportantDate', :as => :important_dateable,
          :dependent => :destroy, :conditions => { :is_start_date => true }
  
  has_one :end, :class_name => 'ImportantDate', :as => :important_dateable,
          :dependent => :destroy, :conditions => { :is_end_date => true }

  has_many :attends, :as => :attendable, :dependent => :destroy
  # has_many :attendees, :through => :attends, :source => :user

  attr_accessible :title, :description, :main_photo_attributes, :other_photos_attributes, :videos_attributes, :website,
                  :location, :other_important_dates_attributes, :user_id, :main_photo,
                  :start_attributes, :end_attributes, :tag_list
  
  accepts_nested_attributes_for :other_photos, :videos, :main_photo,
                                :start, :end, :other_important_dates, :allow_destroy => true  
  
  validates_presence_of :title, :description, :message => "is required"
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode, :if => :location_changed?  # auto-fetch coordinates


  # popular are those having more number of attendees and are upcoming...
  scope :popular,
    select('events.*, count(attends.id) AS attends_size').
    joins("inner join attends on (attends.attendable_id = events.id) ").
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    where("attends.attendable_type = 'Event'").
    group('events.id').
    order('attends_size DESC')

  # newly added upcoming events.
  scope :newly_added,
    select('events.*').
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    group('events.id').
    order('created_at DESC')


  # date ordered on start date
  scope :date_ordered,
    select('events.*').
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    group('events.id').
    order("important_dates.date_time ASC")

  def attendees
    attends.order('created_at').map(&:user)
  end

  def self.upcoming_events
    # Event.joins(:start).where("important_dates.date_time > ? OR important_dates.date_time < ?", Time.now, Time.now)
    Event.joins(:start).where("important_dates.date_time > ?", Time.now)
  end

  def attendees_emails
    attendees.map(&:email)
  end

  def attending?(user)
    attendees.include?(user)
  end

  def liked_by?(user)
    likers.include?(user)
  end

  def self.in_location(query)
    Event.upcoming_events.near(query)
  end

  def self.with_keyword(word)
    Event.upcoming_events.where("title like ?", "%#{word}%")
  end

  def self.search_all(query)
    result = Event.in_location(query) + Event.with_keyword(query)
    result
  end

  def self.search_all_with_pagination(query, page, per_page = 10)
    Kaminari.paginate_array( Event.search_all(query) ).page(page).per(per_page)
  end


  def self.search_new_events(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_new(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).page(page).per(per_page) 
    else
      ordered
    end
  end

  def self.search_popular_events(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_popularity(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).page(page).per(per_page) 
    else
      ordered
    end 
  end

  def self.search_events_order_by_date(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_start_date(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).page(page).per(per_page) 
    else
      ordered
    end 
  end

  def self.order_by_new(events)
    events.sort_by(&:created_at)
  end

  def self.order_by_popularity(events)
    events.sort_by{ |events|
      events.attends.size
    }
  end

  def self.order_by_start_date(events)
    events.sort_by{ |events|
      events.start.date_time
    }
  end


  def self.new_events(page = nil, per_page = 10)
    if page.nil?
      Event.newly_added
    else
      Kaminari.paginate_array(Event.newly_added).page(page).per(per_page)
    end
  end

  def self.popular_events(page = nil, per_page = 10)
    if page.nil?
      Event.popular
    else
      Kaminari.paginate_array(Event.popular).page(page).per(per_page)
    end
  end

  def self.events_ordered_by_date(page = nil, per_page = 10)
    if page.nil?
      Event.date_ordered
    else
      Kaminari.paginate_array(Event.date_ordered).page(page).per(per_page)
    end
  end

  def self.recent_events(page = nil, per_page = 10)
    if page.nil?
      Event.order('created_at DESC')
    else
      Kaminari.paginate_array(Event.order('created_at DESC')).page(page).per(per_page)
    end
  end

  def location_city
    Geocoder.search("#{latitude},#{longitude}").first.try(:city) || location
  end

  def up_voters
    up_votes.map(&:user)
  end

  def down_voters
    down_votes.map(&:user)
  end

  def voted_by_user?(user)
    (up_voters + down_voters).include?(user)
  end

  def voted_type_by_user(user)
    if voted_by_user?(user)
      vote = votes.where(:user_id => user.id).first
      vote.is_up_vote ? 'up' : 'down'
    end
  end

  def up_vote(user)
    if voted_by_user?(user)
      votes.where(:user_id => user.id).first.destroy
    end
    up_votes.create(:user => user, :is_up_vote => true)
  end

  def down_vote(user)
    if voted_by_user?(user)
      votes.where(:user_id => user.id).first.destroy
    end
    down_votes.create(:user => user, :is_down_vote => true)
  end

  def as_json(options = {})

    json = super(options)
    if options[:check_user].present?
      # tells if the user is attending particular event.
      json[:user_attending] = self.attending?(options[:check_user])
      json[:user_liked] = self.likes.pluck("user_id").include?(options[:check_user].id)
    end

    if options[:votes_data_for_user].present?
      user = options[:votes_data_for_user]
      json[:voted_by_user] = voted_by_user?(user)
      json[:voted_type_by_user] = voted_type_by_user(user)
    end

    if options[:for_search].present? and options[:for_search] == true
      json[:thumbnail] = main_photo.image.url(:medium)
      json[:label] = title
      json[:value] = title
      json[:category]= 'Events'
      json[:url] = "/events/#{id}"
    end

    json
  end

  # cummulative of up and down votes
  def votes_count
    up_votes.count - down_votes.count
  end

  def self.custom_json(events, user = nil)
    # user is passed to include if he is attending the event.
    events.to_json(:include => [
                      :user,
                      :comments,
                      :main_photo,
                      :likes,
                      { 
                        :start => {
                          :methods => [
                            :day,
                            :month_year,
                            :pretty_date,
                            :formatted_time
                          ]
                        }
                      },
                      { 
                        :end => {
                          :methods => [
                            :day,
                            :month_year,
                            :pretty_date
                          ]
                        }
                      }
                    ],
                    :methods => [
                      :attendees,
                      :distance,
                      :votes_count
                    ],
                    :check_user => user,
                    :votes_data_for_user => user
                  )
  end

  def similar_events
    self.nearbys.first(3)
  end

  def self.search_events(query)
    Event.where('title like ? or description like ?', "%#{query}%", "%#{query}%")
  end

  def valid_videos
    videos.where('provider IS NOT NULL')
  end

end