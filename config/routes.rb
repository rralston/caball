Caball::Application.routes.draw do

  match 'users/show' => 'users#show'
  match 'projects/show' => 'projects#show'
  
end
