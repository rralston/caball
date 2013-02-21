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
end
