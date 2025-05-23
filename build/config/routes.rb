Rails.application.routes.draw do

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")S
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

  #Google Auth
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/failure', to: redirect('/')

  match '/auth/:provider', to: 'sessions#passthru', via: [:get, :post]

  # User Profile
  get "profile_page/profile_index"


end