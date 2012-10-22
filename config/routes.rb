Caball::Application.routes.draw do
  resources :users
  resources :characteristics
  
  match 'projects/show' => 'projects#show'

  namespace :admin do
    %w[index interface buttons calendar charts chat gallery grid invoice login tables widgets form_wizard form_common form_validation].each do |page|
      get 'admin/' + page
    end
  end
end
