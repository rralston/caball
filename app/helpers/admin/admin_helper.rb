module Admin::AdminHelper
  def is_active?(page_name)
    "active" if params[:action] == page_name
  end
  def open?(*names)
    names.map {|t| 
      if params[:action] == (t)
        "submenu active open" 
      else 
        "submenu"
      end }
    end
  end