class Admin::AdminController < Admin::BaseController
  
  def index
    @users = User.all.count
    @projects = Project.all.count
  end
  def interface
  end
  def buttons
  end
  def calendar
  end
  def charts
  end
  def chat
  end
  def gallery
  end
  def grid
  end
  def invoice
  end
  def login
  end
  def tables
  end
  def widgets
  end
  def form_wizard
  end
  def form_common
  end
  def form_validation
  end
end

