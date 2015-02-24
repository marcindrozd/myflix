Myflix::Application.routes.draw do
  root 'pages#front'

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/register', to: "users#new"
  delete '/sign_out', to: "sessions#destroy"

  get 'ui(/:action)', controller: 'ui'

  get '/home', to: "videos#index"
  resources :videos, only: [:show] do
    collection do
      get '/search', to: "videos#search"
    end
  end

  resources :users, only: [:create]

  get '/categories/:id', to: "categories#show", as: "category"
end
