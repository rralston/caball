module AdminHelper
  def is_active?(page_name)
    "active" if params[:action] == page_name
  end
  def menu_open?(page_name, page_name2, page_name3)
    if params[:action] == page_name || params[:action] == page_name2 || params[:action] == page_name3 
      "submenu active open" 
    else 
      "submenu"
    end
  end
  def menu_open2?(page_name, page_name2, page_name3, page_name4)
     if params[:action] == page_name || params[:action] == page_name2 || params[:action] == page_name3 || params[:action] == page_name4
        "submenu active open" 
      else 
        "submenu"
      end
    end
end