class Event < ActiveRecord::Base
  include PublicActivity::Model
  include ActionView::Helpers
  tracked owner: ->(controller, model) { controller && controller.current_user }

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
  has_many :attendees, :through => :attends, :source => :user

  attr_accessible :title, :description, :main_photo_attributes, :other_photos_attributes, :videos_attributes, :website,
                  :location, :other_important_dates_attributes, :user_id, :main_photo,
                  :start_attributes, :end_attributes, :tag_list
  
  accepts_nested_attributes_for :other_photos, :videos, :main_photo,
                                :start, :end, :other_important_dates, :allow_destroy => true  
  
  validates_presence_of :title, :description, :location, :message => "is required"
  
  geocoded_by :location   # can also be an IP address
  after_validation :geocode, :if => :location_changed?  # auto-fetch coordinates


  before_save :update_url_name

  def update_url_name
    if self.title_changed?

      new_title = truncate(self.title, :length => 120, :separator => ' ', :omission => '')
      
      # if the name is changed, convert to the url name
      if new_title.start_with?(*('0'..'9'))
        self.url_name = "the-"+new_title.gsub(/\s/,'-').gsub(/[^a-zA-Z0-9-]/, '').downcase
      else
        self.url_name = new_title.gsub(/\s/,'-').gsub(/[^a-zA-Z0-9-]/, '').downcase
      end

      if self.id.present?
        same_named_count = Event.where("lower(url_name) like lower(?) and id <> ? ",  "#{self.url_name}%", self.id).size
      else
        # check  and get size of if any other Events having the same url_name
        same_named_count = Event.where("lower(url_name) like lower(?)", "#{self.url_name}%").size
      end
      
      if same_named_count > 0
        if self.id.present?
          # append the id after the url_name.
          self.url_name = self.url_name + "-#{self.id}"
        else
          total_entities = Event.last.id rescue 0
          self.url_name = self.url_name + "-#{total_entities.to_i + 1}"
        end
      end
    end
  end

  # popular are those having more number of total votes...
  # total_votes is (sum of upvotes) - (sum of down votes)
  # vote.value is 1 for upvote, -1 for downvote.
  scope :popular,
    select('events.*, SUM(votes.value) AS votes_total').
    joins("inner join votes on votes.votable_id = events.id and votes.votable_type = 'Event' ").
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    group('events.id').
    order('votes_total DESC')

  # newly added upcoming events.
  scope :newly_added,
    select('events.*').
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    group('events.id').
    order('events.created_at DESC')


  # date ordered on start date
  scope :date_ordered,
    select('events.*').
    joins("inner join important_dates ON important_dates.important_dateable_id = events.id AND important_dates.is_start_date = true AND important_dates.important_dateable_type = 'Event'").
    where("important_dates.date_time > ?", Time.now).
    group('events.id, important_dates.date_time').
    order("important_dates.date_time ASC")

  # def attendees
  #   attends.order('created_at').map(&:user)
  # end

  def self.upcoming_events
    Event.joins(:start).where("important_dates.date_time > ?", Time.now)
  end

  def attendees_emails
    attendees.pluck("users.email")
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
    Event.upcoming_events.where("lower(title) like lower(?)", "%#{word}%")
  end

  def self.search_all(query)
    result = Event.in_location(query) + Event.with_keyword(query)
    result
  end

  def self.search_all_with_pagination(query, page, per_page = 10)
    Kaminari.paginate_array( Event.search_all(query) ).per_page_kaminari(page).per(per_page)
  end


  def self.search_new_events(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_new(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).per_page_kaminari(page).per(per_page) 
    else
      ordered
    end
  end

  def self.search_popular_events(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_popularity(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).per_page_kaminari(page).per(per_page) 
    else
      ordered
    end 
  end

  def self.search_events_order_by_date(query, page = nil, per_page = 10)
    search_result = Event.search_all(query)
    ordered = Event.order_by_start_date(search_result).reverse
    if page.present?
      Kaminari.paginate_array( ordered ).per_page_kaminari(page).per(per_page) 
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
      Kaminari.paginate_array(Event.newly_added).per_page_kaminari(page).per(per_page)
    end
  end

  def self.popular_events(page = nil, per_page = 10)
    if page.nil?
      Event.popular
    else
      Kaminari.paginate_array(Event.popular).per_page_kaminari(page).per(per_page)
    end
  end

  def self.events_ordered_by_date(page = nil, per_page = 10)
    if page.nil?
      Event.date_ordered
    else
      Kaminari.paginate_array(Event.date_ordered).per_page_kaminari(page).per(per_page)
    end
  end

  def self.recent_events(page = nil, per_page = 10)
    if page.nil?
      Event.order('created_at DESC')
    else
      Kaminari.paginate_array(Event.order('created_at DESC')).per_page_kaminari(page).per(per_page)
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
      json[:thumbnail] = main_photo.image.url(:thumb)
      json[:label] = title
      json[:value] = title
      json[:category]= 'Events'
      json[:url] = "/events/#{id}"
    end

    if options[:comments_count].present? and options[:comments_count] == true
      json[:comments_count] = comments.count
    end

    if options[:likes_count].present? and options[:likes_count] == true
      json[:likes_count] = likes.count
    end

    if options[:include_attendees].present? and options[:include_attendees] == true
      json[:attendees] = attendees.last(5)
    end

    json[:url_param] = url_param
    json
  end

  # cummulative of up and down votes
  def votes_count
    Vote.select('SUM(votes.value) AS total').
          where("votes.votable_id = ? AND votes.votable_type = ? ", self.id, 'Event').
          first.total.to_i
  end

  def self.custom_json(events, user = nil, comments_count = true, likes_count = true, include_attendees = true )
    # user is passed to include if he is attending the event.
    events.to_json(:include => [
                      :user,
                      :main_photo,
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
                      :distance,
                      :votes_count
                    ],
                    :check_user => user,
                    :votes_data_for_user => user,
                    :comments_count => comments_count,
                    :likes_count => likes_count,
                    :include_attendees => include_attendees
                  )
  end

  def similar_events
    self.nearbys.first(3) rescue []
  end

  def self.search_events(query)
    Event.where('lower(title) like lower(?) or lower(description) like lower(?)', "%#{query}%", "%#{query}%")
  end

  def valid_videos
    videos.where('provider IS NOT NULL')
  end

  def all_photos
    [self.main_photo] + self.other_photos
  end

  def url_param
    url_name.present? ? url_name : id
  end

end