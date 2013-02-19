Caball::Application.routes.draw do
  resources :users do 
    resources :characteristics, :photos, :talents
  end
  
  resources :projects
  
  # Static Pages 
  
  resources :home, except: :show  
  %w[privacy terms about].each do |page|
    get page, controller: "home", action: page
  end

  match 'projects/show' => 'projects#show'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  root :to => 'home#index'
  
  # Admin Area
  namespace :admin do
    %w[index users projects interface buttons calendar charts chat gallery grid invoice login tables widgets form_wizard form_common form_validation].each do |page|
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
