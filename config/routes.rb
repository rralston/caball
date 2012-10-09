Caball::Application.routes.draw do

  get "admin/index"

  match 'users/show' => 'users#show'
  match 'projects/show' => 'projects#show'
  
  get "admin/index"
  get "admin/interface"
  get "admin/buttons"
  get "admin/calendar"
  get "admin/charts"
  get "admin/chat"
  get "admin/gallery"
  get "admin/grid"
  get "admin/invoice"
  get "admin/login"
  get "admin/tables"
  get "admin/widgets"
  get "admin/form_wizard"
  get "admin/form_common"
  get "admin/form_validation"
  match ':permalink', :controller => 'admin', :action => 'show', :as => 'my_page'
  
end
