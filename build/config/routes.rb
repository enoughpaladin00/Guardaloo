Rails.application.routes.draw do
  # Defines the root path route ("/")
  get 'home/index'
  root "home#index"

  # Registrazione
  get "signup", to: "registrations#new"
  post "/register", to: "registrations#create"

  # Login / Logout
  get "login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  #movie
  get "movies/show"
  resources :movies, only: [:show]

  #homepage
  get "home", to: "homepage#homepage"

  #Google and Facebook Auth
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/failure', to: redirect('/')

  match '/auth/:provider', to: 'sessions#passthru', via: [:get, :post]

  Rails.application.routes.draw do
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  #health check?
  get "up" => "rails/health#show", as: :rails_health_check


end
