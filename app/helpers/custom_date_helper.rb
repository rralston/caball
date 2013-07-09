module CustomDateHelper
  def date_time_summary(timestamp)
    if timestamp > Time.now.beginning_of_day 
      "#{time_ago_in_words(timestamp)} ago"
    else
      "on #{timestamp.strftime("%A %d %B %Y at %I:%M%p")}"
    end
  end
end