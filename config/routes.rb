Caball::Application.routes.draw do
  resources :users do 
    resources :characteristics, :photos
  end
  
  match 'projects/show' => 'projects#show'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  root :to => 'users#index'
  
  namespace :admin do
    %w[index interface buttons calendar charts chat gallery grid invoice login tables widgets form_wizard form_common form_validation].each do |page|
      get 'admin/' + page
    end
  end
end
