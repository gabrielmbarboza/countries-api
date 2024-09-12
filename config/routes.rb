Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "posts#index"
  
  post '/login', to: 'sessions#login'
  post '/signup', to: 'sessions#signup'

  namespace :api do
    concern :base do
      resources :countries, except: %i[new edit]
    end

    namespace :v1 do
      concerns :base
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
