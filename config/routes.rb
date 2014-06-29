PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new'

  resources :users, only: [:create, :index]
  #post '/users', to: 'users#create'
  #get '/users', to: 'users#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do 
    resources :comments, only: [:create]
  end

  resources :categories, only: [:new, :create, :show]
end
