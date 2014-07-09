PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do 
    resources :comments, only: [:create] do
      member do
        post 'vote'
        patch 'vote_change'     
      end
    end

    member do
      post 'vote'
      patch 'vote_change'
    end
  end

  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :edit, :update, :show, :index,]
end
