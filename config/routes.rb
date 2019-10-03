Rails.application.routes.draw do
  # site layout
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  # Sign up handler
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  # login handler
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # users
  resources :users
  resources :account_activations, only: %i[edit]
end
