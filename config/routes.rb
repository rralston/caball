Caball::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "users/registrations", :sessions => "users/sessions"}

  get "/projects", to: redirect("http://filmmo.com/projects")
  get "/projects/index" => redirect("http://filmmo.com/projects/index")
  get "/projects/show" => redirect("http://filmmo.com/projects/show")
  get '/projects/:id', to: redirect('http://filmmo.com/projects/%{id}')
  get '/projects/:name', to: redirect('http://filmmo.com/projects/%{name}')
  get "/users", to: redirect("http://filmmo.com/users")
  get "/users/index" => redirect("http://filmmo.com/users/index")
  get "/users/show" => redirect("http://filmmo.com/users/show")
  get '/users/:id', to: redirect('http://filmmo.com/users/%{id}')
  get '/users/:name', to: redirect('http://filmmo.com/users/%{name}')
  get "/people", to: redirect("http://filmmo.com/people")
  get "/people/index" => redirect("http://filmmo.com/people/index")
  get "/people/show" => redirect("http://filmmo.com/people/show")
  get '/people/:id', to: redirect('http://filmmo.com/people/%{id}')
  get '/people/:name', to: redirect('http://filmmo.com/people/%{name}')
  root :to => 'home#index'

  get "activities/index"

  match '/our_story', to: redirect("http://filmmo.com/static_pages#our_story")
  match '/contact', to: redirect("http://filmmo.com/contact_us/contacts#new")
  match '/contact_us', to: redirect("http://filmmo.com/contact_us/contacts#new")
  # get 'people', to: 'users#index', via: :all
  resources :users, :path => "people"
  match '/people/:id' => 'users#update', :via => 'post'
  match "/blog(/*path)" => redirect{ |env, req| "http://blog.filmzu.com" + (req.path ? "#{req.path}" : '/')}

  match 'check_url_param' => 'application#check_url_param'

  match "/main_search" => 'application#main_search'

  match 'users/recommended_projects' => 'users#next_recommended_projects'
  match 'users/recommended_people' => 'users#next_recommended_people'
  match 'users/recommended_events' => 'users#next_recommended_events'

  match '/users/set_notification_check_time' => 'users#set_notification_check_time'

  match '/users/update' => 'users#custom_update', :via => 'POST'
  match '/users/step_1' => 'users#step_1'

  match '/users/step_1_reload' => 'users#step_1_reload'
  match '/users/step_2' => 'users#step_2'
  match '/users/step_3' => 'users#step_3'
  match '/users/files_upload' => 'users#files_upload'
  match '/users/agent_names' => 'users#agent_names'
  match '/users/profile' => 'users#profile'
  match '/users/change_password' => 'users#change_password'
  match '/users/change_email' => 'users#change_email'
  match '/users/change_email_settings' => 'users#change_email_settings'
  get '/users/search_by_name'  

  match '/events/files_upload' => 'events#files_upload'
  match '/projects/files_upload' => 'projects#files_upload'
  match '/comments/files_upload' => 'comments#files_upload'
  match '/blogs/files_upload' => 'blogs#files_upload'

  resources :users do 
    resources :characteristics, :photos, :talents, :profile, :blogs
  end


  match '/roles/destroy' => 'roles#destroy', :via => 'POST'


  match '/projects/step_1'          => 'projects#step_1'
  match '/projects/step_2'          => 'projects#step_2'
  match '/projects/step_3'          => 'projects#step_3'
  match '/projects/add_filled_role' => 'projects#add_filled_role'


  resources :projects do 
    resources :comments
  end

  match '/blogs/:id' => 'blogs#update', :via => 'POST'
  resources :blogs
  # post request to handle comment handle
  match '/comments/:id' => 'comments#update', :via => 'POST'
  resources :comments
  match 'conversations/get_messages' => 'conversations#get_messages', :via => 'GET'
  match '/conversations/empty_trash' => 'conversations#empty_trash', :via => 'POST'
  resources :conversations
  match 'conversations/send-generic-message' => 'conversations#send_message_generic', :via => 'POST'

  resources :notifications
  resources :friendships
  match 'friendships/destroy' => 'friendships#destroy', :via => 'POST'
  resources :likes
  match 'likes/unlike' => 'likes#unlike', :via => 'POST'

  resources :endorsements

  resources :events
  match 'events/up_vote' => 'events#up_vote', :via => 'POST'
  match 'events/down_vote' => 'events#down_vote', :via => 'POST'
  match 'events/load_more' => 'events#load_more', :via => 'POST'
  match 'events/message_organizer' => 'events#send_message_to_organizer', :via => 'POST'
  match 'events/attend' => 'events#attend', :via => 'POST'
  match 'events/unattend' => 'events#unattend', :via => 'POST'
  match 'events/invite_followers' => 'events#invite_followers', :via => 'POST'

  resources :role_applications do
    get :already_approved
  end
  match 'roles_applicants' => 'roles#applicants_list', :via => 'POST'
  match 'role_applications/approve' => 'role_applications#approve', :via => 'POST'
  match 'role_applications/un_approve' => 'role_applications#un_approve', :via => 'POST'

  match 'report' => 'application#report'

  # News feed
  match 'activities/load_more' => 'activities#next_activities'
  resources :activities


  # Static Pages 

  resources :home, except: :show  
  %w[privacy terms about opportunities FAQ glossary labs partners beta skills].each do |page|
    get page, controller: "static_pages", action: page
  end

  match 'dashboard'                 => 'users#dashboard'
  match 'dashboard/projects'        => 'users#dashboard_projects', :via => 'GET'
  match 'dashboard/events'          => 'users#dashboard_events', :via => 'GET'
  match 'dashboard/conversations'   => 'users#dashboard_conversations', :via => 'GET'
  match '/dashboard/manage_project' => 'users#manage_project', :via => 'GET'


  match 'projects/show' => 'projects#show'
  # match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  # Admin Area
  namespace :admin do
    %w[index users user_images interrogate projects project_images events event_images messages interface buttons calendar charts chat gallery grid invoice login tables widgets form_wizard form_common form_validation ].each do |page|
      get 'admin/' + page
    end

    put 'admin/update_user'
    put 'admin/update_project'
  end

  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
      post :unread
      post :read
    end
  end
end
