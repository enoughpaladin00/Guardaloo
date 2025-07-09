Rails.application.routes.draw do
  # Root path
  root "home#index"

  # Static pages
  get "home/index"
  get "home", to: "homepage#homepage"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication
  get "signup", to: "registrations#new"
  post "/register", to: "registrations#create"

  get "login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Omniauth (Google, Facebook)
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")
  match "/auth/:provider", to: "sessions#passthru", via: [ :get, :post ]

  # User Profile
  get "/profile", to: "profile_page#profile_index", as: "profile"
  get "/profile/edit", to: "profile_page#edit", as: "edit_profile"
  patch "/profile", to: "profile_page#update"

  get "/movie_search", to: "profile_page#movie_search"
  post "/profile/update_movie", to: "profile_page#update_movie", as: "update_movie"


  # Location
  post "/set_location", to: "sessions#set_location"
  # Update favourite film ids for User Profile
  patch "/users/update_tmdb_id", to: "users#update_tmdb_id"

  # Google and Facebook Auth
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")

  # Movie Routes
  get "movies/search", to: "movies#search"
  get "movies/:tmdb_id", to: "movies#show", as: "movie_show"

  # TMDB Search
  get "/tmdb_search", to: "search#tmdb"

  # Posts and Comments
  resources :posts do
    resources :comments, only: [ :create, :update, :destroy ]
  end

  # Cinema
  resources :cinemas, only: [ :index ] do
    member do
      get "programmazione"
    end
  end

  # Favorite Cinemas
  resources :cinema_favorites, only: [ :create, :destroy ]
  post "/bookmarks/toggle", to: "bookmarks#toggle", as: "bookmarks_toggle"

  # Role change
  resources :users do
    member do
      patch :toggle_role
    end
  end

end
