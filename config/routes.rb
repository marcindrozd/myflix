Myflix::Application.routes.draw do
  root 'pages#front'

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/register', to: "users#new"
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

  resources :users, only: [:create, :show, :index]
  resources :categories, only: [:show]
  resources :friendships, only: [:destroy]

  get 'ui(/:action)', controller: 'ui'
end
