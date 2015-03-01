Myflix::Application.routes.draw do
  root 'pages#front'

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/register', to: "users#new"
  delete '/sign_out', to: "sessions#destroy"

  get 'ui(/:action)', controller: 'ui'

  get '/home', to: "videos#index"

  get '/my_queue', to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]

  resources :videos, only: [:show] do
    collection do
      get '/search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]
  resources :categories, only: [:show]
end
