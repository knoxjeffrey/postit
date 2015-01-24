PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/pin', to: 'sessions#pin'
  post '/pin', to: 'sessions#pin'
  
  resources :posts, except: [:destroy] do
    post :vote, on: :member #will recognise /posts/id/vote with POST and route to vote method in PostsController
    resources :comments, only: [:create] do
      post :vote, on: :member #will recognise /posts/id/comments/id/vote vote with POST and route to vote method in CommentsController
    end
  end
    
  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :show, :edit, :update ]
  
end
