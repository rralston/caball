module RedirectHelper
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  private
  
  def clear_return_to
    session.delete(:return_to)
  end
end