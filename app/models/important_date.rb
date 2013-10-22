class ImportantDate < ActiveRecord::Base
  belongs_to :important_dateable, :polymorphic => true

  attr_accessible :description, :date_time, :is_start_date, :is_end_date, :date, :time_string

  validates_presence_of :date, :message => "is required"
  validates_presence_of :description, :message => "is required", :if => :is_not_start_or_end?

  before_save :update_date_time

  def update_date_time
    if self.date_changed? or self.time_string_changed?
      self.date_time = Time.parse("#{self.date} #{self.time_string}").to_s.split(' ').first(2).join(' ')
      # take only the date time the user enters and save, first(2) is to ignore the timezone difference calculated.
    end
  end


  def full_date
    date_time.split(' ').first
  end

  def day
    full_date.split('-').last
  end

  def year
    full_date.split('-').first
  end

  def month
    full_date.split('-')[1]
  end

  def month_string
    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']
    months[month.to_i-1]
  end

  def month_year
    "#{month_string} \'#{year.last(2)}"
  end

  def time
    date_time.split(' ').last
  end

  def formatted_time
    Time.parse(time).strftime("%I:%M%P")
  end

  def is_not_start_or_end?
    not is_start_date || is_end_date
  end

  def pretty_date
    "#{month_string} #{day}, #{year} #{formatted_time}"
  end

end