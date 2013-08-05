class ProjectDate < ActiveRecord::Base
  belongs_to :project

  attr_accessible :description, :date_time

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

end