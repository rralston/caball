module ApplicationHelper
  def notice
    flash[:notice]
  end

  def alert
    flash[:alert]
  end
  
  def comment
    # use this keyword in the views, to comment-out stuff...
  end
  
  def shorten(args)
    if args[:counter].present?
      @counter = args[:counter]
    end
    length = args[:length]
    text = args[:text]
    partial = args[:partial]
    output = truncate(text, :length => length, :omission => '...').html_safe
    more_button = render :partial => partial
    output += more_button if text.length > length
    output
  end
  
end
