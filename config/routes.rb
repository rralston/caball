Caball::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "users/registrations", :sessions => "users/sessions",
                                       :passwords => "users/passwords"}

  get "activities/index"

  match "/skills(/*path)" => redirect{ |env, req| "http://skills.filmzu.com" + (req.path ? "#{req.path}" : '/')}


  match "/main_search" => 'application#main_search'

  match 'users/recommended_projects' => 'users#next_recommended_projects'
  match 'users/recommended_people' => 'users#next_recommended_people'
  match 'users/recommended_events' => 'users#next_recommended_events'

  match '/users/set_notification_check_time' => 'users#set_notification_check_time'

  match '/users/update' => 'users#custom_update', :via => 'POST'
  match '/users/step_1' => 'users#step_1'
  match '/users/step_2' => 'users#step_2'
  match '/users/step_3' => 'users#step_3'
  match '/users/files_upload' => 'users#files_upload'
  match '/users/agent_names' => 'users#agent_names'
  

  match '/events/files_upload' => 'events#files_upload'

  resources :users do 
    resources :characteristics, :photos, :talents, :profile, :blogs
  end

  
  resources :projects do 
    resources :comments
  end
  resources :blogs
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

  resources :role_applications
  match 'roles_applicants' => 'roles#applicants_list', :via => 'POST'
  match 'role_applications/approve' => 'role_applications#approve', :via => 'POST'
  match 'role_applications/un_approve' => 'role_applications#un_approve', :via => 'POST'

  match 'report' => 'application#report'
  
  # News feed
  match 'activities/load_more' => 'activities#next_activities'
  resources :activities
  
  
  # Static Pages 
  
  resources :home, except: :show  
  %w[privacy terms about].each do |page|
    get page, controller: "home", action: page
  end

  match 'dashboard'               => 'users#dashboard'
  match 'dashboard/projects'      => 'users#dashboard_projects', :via => 'GET'
  match 'dashboard/events'        => 'users#dashboard_events', :via => 'GET'
  match 'dashboard/conversations' => 'users#dashboard_conversations', :via => 'GET'

  match 'projects/show' => 'projects#show'
  # match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  root :to => 'home#index'
  
  # Admin Area
  namespace :admin do
    %w[index users user_images interrogate projects project_images messages interface buttons calendar charts chat gallery grid invoice login tables widgets form_wizard form_common form_validation].each do |page|
      get 'admin/' + page
    end
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
