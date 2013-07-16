class ImportantDate < ActiveRecord::Base
  belongs_to :important_dateable, :polymorphic => true

  attr_accessible :description, :date_time, :is_start_date, :is_end_date

  validates_presence_of :date_time, :message => "is required"
  validates_presence_of :description, :message => "is required", :if => :is_not_start_or_end?

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

  def month_year
    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']
    "#{months[month.to_i-1]} \'#{year.last(2)}"
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

end