Caball::Application.routes.draw do
  get "pages/index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "users/registrations", :sessions => "users/sessions"}

  get "activities/index"

  get '/our_story' => 'static_pages#our_story'
  get '/contact' => 'contact_us/contacts#new'
  #get '/contact_us' => 'contact_us/contacts#new'
  # get 'people', to: 'users#index', via: :all
  resources :users, :path => "people"
  get '/people/:id' => 'users#update', :via => 'post'
  get "/blog(/*path)" => redirect{ |env, req| "http://blog.filmzu.com" + (req.path ? "#{req.path}" : '/')}

  get 'check_url_param' => 'application#check_url_param'

  get "/main_search" => 'application#main_search'

  get 'users/recommended_projects' => 'users#next_recommended_projects'
  get 'users/recommended_people' => 'users#next_recommended_people'
  get 'users/recommended_events' => 'users#next_recommended_events'

  get '/users/set_notification_check_time' => 'users#set_notification_check_time'

  post '/users/update' => 'users#custom_update'
  get '/users/step_1' => 'users#step_1'

  get '/users/step_1_reload' => 'users#step_1_reload'
  get '/users/step_2' => 'users#step_2'
  get '/users/step_3' => 'users#step_3'
  get '/users/files_upload' => 'users#files_upload'
  get '/users/agent_names' => 'users#agent_names'
  get '/users/profile' => 'users#profile'
  get '/users/change_password' => 'users#change_password'
  get '/users/change_email' => 'users#change_email'
  get '/users/change_email_settings' => 'users#change_email_settings'
  get '/users/search_by_name'  

  get '/events/files_upload' => 'events#files_upload'
  get '/projects/files_upload' => 'projects#files_upload'
  get '/comments/files_upload' => 'comments#files_upload'
  get '/blogs/files_upload' => 'blogs#files_upload'

  resources :users do 
    resources :characteristics, :photos, :talents, :profile, :blogs
  end


  post '/roles/destroy' => 'roles#destroy'


  get '/projects/step_1'          => 'projects#step_1'
  get '/projects/step_2'          => 'projects#step_2'
  get '/projects/step_3'          => 'projects#step_3'
  get '/projects/add_filled_role' => 'projects#add_filled_role'


  resources :projects do 
    resources :comments
  end

  post '/blogs/:id' => 'blogs#update'
  resources :blogs
  # post request to handle comment handle
  post '/comments/:id' => 'comments#update'
  resources :comments
  get 'conversations/get_messages' => 'conversations#get_messages'
  post '/conversations/empty_trash' => 'conversations#empty_trash'
  resources :conversations
  post 'conversations/send-generic-message' => 'conversations#send_message_generic'

  resources :notifications
  resources :friendships
  post 'friendships/destroy' => 'friendships#destroy'
  resources :likes
  post 'likes/unlike' => 'likes#unlike'

  resources :endorsements
 
  resources :events
  post 'events/up_vote' => 'events#up_vote'
  post 'events/down_vote' => 'events#down_vote'
  post 'events/load_more' => 'events#load_more'
  post 'events/message_organizer' => 'events#send_message_to_organizer'
  post 'events/attend' => 'events#attend'
  post 'events/unattend' => 'events#unattend'
  post 'events/invite_followers' => 'events#invite_followers'

  resources :role_applications do
    get :already_approved
  end
  post 'roles_applicants' => 'roles#applicants_list'
  post 'role_applications/approve' => 'role_applications#approve'
  post 'role_applications/un_approve' => 'role_applications#un_approve'

  post 'report' => 'application#report'
  
  # News feed
  get 'activities/load_more' => 'activities#next_activities'
  resources :activities
  
  
  # Static Pages 
  
  resources :home, except: :show  
  %w[privacy terms about opportunities FAQ glossary labs partners beta skills].each do |page|
    get page, controller: "static_pages", action: page
  end

  get 'dashboard'                 => 'users#dashboard'
  get 'dashboard/projects'        => 'users#dashboard_projects'
  get 'dashboard/events'          => 'users#dashboard_events'
  get 'dashboard/conversations'   => 'users#dashboard_conversations'
  get '/dashboard/manage_project' => 'users#manage_project'
  

  get 'projects/show' => 'projects#show'
  # match 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'


  root :to => 'pages#index'
  get 'register' => 'pages#register', as: 'register'

  
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
