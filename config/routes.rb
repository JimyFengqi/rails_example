Rails.application.routes.draw do
  get 'login',        to: 'sessions#new'
  post 'login',       to: 'sessions#create'
  delete 'logout',    to: 'sessions#destroy'

  root 'static_pages#home'
  #get  '/home',    to: 'static_pages#home'
  get  '/help',       to: 'static_pages#help' #, as: '/helf'
  get  '/about',      to: 'static_pages#about'
  get  '/contact',    to: 'static_pages#contact'
  get  '/signup',     to: 'users#new'
  post '/signup',     to: 'users#create'
  get  '/users/show', to: 'users#show'
  #get 'users/new'

  resources :users
  resources :account_activations, only:[:edit]
  #resources :users
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'


  #root 'application#hello'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
