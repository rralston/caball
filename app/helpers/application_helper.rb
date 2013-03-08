module ApplicationHelper
  def notice
    flash[:notice]
  end

  def alert
    flash[:alert]
  end
  
  def error
    flash[:error]
  end
  
  def comment
    # use this keyword in the views, to comment-out stuff...
  end
  
  def shorten(args)
    if args[:counter].present?
      @counter = args[:counter]
    end
    show_more_anyways = false
    if args[:show_more] == true
      show_more = true
    end
    length = args[:length]
    text = args[:text]
    partial = args[:partial]
    output = truncate(text, :length => length, :omission => '...').html_safe
    more_button = render :partial => partial
    output += more_button if text.length > length or show_more
    output
  end
  
  def google_analytics_js(id = nil)
 
    content_tag(:script, :type => 'text/javascript') do
        "var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-38653918-1']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();"
    end if !id.blank? && Rails.env.production?
  end
end
