Myflix::Application.routes.draw do
  root 'pages#front'

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/register', to: "users#new"
  get '/register/:token', to: "users#new_with_invite", as: "register_with_token"
  delete '/sign_out', to: "sessions#destroy"

  get '/home', to: "videos#index"

  resources :queue_items, only: [:create, :destroy]
  get '/my_queue', to: "queue_items#index"
  post 'update_queue', to: "queue_items#update_queue"

  resources :videos, only: [:show] do
    collection do
      get '/search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:create, :show]
  get '/people', to: "friendships#index"

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  get '/forgot_password', to: "passwords#forgot_password"
  post '/request_token', to: "passwords#request_token"
  get '/confirm_password_reset', to: "passwords#confirm_password_reset"
  get '/reset_password', to: "passwords#reset_password"
  post '/new_password', to: "passwords#new_password"
  get '/invalid_token', to: "passwords#invalid_token"

  resources :categories, only: [:show]
  resources :friendships, only: [:create, :destroy]
  resources :invites, only: [:new, :create]

  mount StripeEvent::Engine, at: '/stripe_events'

  get 'ui(/:action)', controller: 'ui'
end
