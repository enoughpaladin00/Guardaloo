Rails.application.routes.draw do
  get "cinemas/index"
  get "home/index"
  get "/cinemas", to: "cinemas#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  # Registrazione
  get "signup", to: "registrations#new"
  post "/register", to: "registrations#create"

  # Login / Logout
  get "login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # movie
  get "movies/:tmdb_id", to: "movies#show", as: "movie_show"

  ## route per location
  post "/set_location", to: "sessions#set_location"

  # homepage
  get "home", to: "homepage#homepage"

  # Google and Facebook Auth
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")

  match "/auth/:provider", to: "sessions#passthru", via: [ :get, :post ]
end
