Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :matches, only: %i[create new]
  # Defines the root path route ("/")
  # root "articles#index"
  get '/positions', to: 'positions#index'
  #post '/matches', to: 'matches#create'
end
