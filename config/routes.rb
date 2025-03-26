Rails.application.routes.draw do
  resource :session, only: [ :new, :create, :destroy ]
  resources :salahs, only: [ :new, :create ]

  # Root path should direct to the login page
  root to: "sessions#new"
  # get "/session", to: redirect("/session/new")
  # get "/salahs/index", to: "salahs#index"
  # Health check (optional)
  get "up" => "rails/health#show", as: :rails_health_check
end
