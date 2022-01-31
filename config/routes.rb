Rails.application.routes.draw do
  resources :foods
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'about', to: 'pages#about'
  get 'foods/:id/add_1', to: 'foods#add_1'
  get 'foods/:id/remove_1', to: 'foods#remove_1'
  get 'foods/:id/changes', to: 'foods#changes'
  # Defines the root path route ("/")
  #root 'pages#home'
  root 'pages#about'
end
