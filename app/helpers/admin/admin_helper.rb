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
      end 
    }
  end

  def objects_created_within_date_range(objects_array, start_time, end_time)
    objects_array.select do |object|
      object.created_at >= start_time && object.created_at < end_time
    end
  end

end