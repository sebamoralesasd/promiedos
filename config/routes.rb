Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect('/positions')
  resources :matches, only: %i[create new index show]
  resources :tournaments, only: %i[create new]
  resources :cups, only: %i[index new create]
  get '/positions', to: 'positions#index'
  get '/positions/last', to: 'positions#last'
  get '/historical', to: 'historical#index'
end
