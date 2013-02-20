module UsersHelper
  
  def shorten(args)
    length = args[:length]
    text = args[:text]
    partial = args[:partial]
    output = truncate(text, :length => length, :omission => '...').html_safe
    more_button = render :partial => partial
    output += more_button if @user.about.size > 800
    output
  end
  
end
