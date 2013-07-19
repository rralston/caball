Caball::Application.routes.draw do
  get "activities/index"

  match "/skills(/*path)" => redirect{ |env, req| "http://skills.filmzu.com" + (req.path ? "#{req.path}" : '/')}

  match 'users/recommended_projects' => 'users#next_recommended_projects'
  match 'users/recommended_people' => 'users#next_recommended_people'

  resources :users do 
    resources :characteristics, :photos, :talents, :profile, :blogs
  end
  
  resources :projects do 
    resources :comments
  end
  resources :comments
  resources :conversations
  resources :notifications
  resources :friendships
  resources :likes
  match 'likes/unlike' => 'likes#unlike', :via => 'POST'

  resources :endorsements
 
  resources :events
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

  match 'dashboard' => 'users#dashboard'

  match 'projects/show' => 'projects#show'
  match 'auth/:provider/callback', to: 'sessions#create'
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
