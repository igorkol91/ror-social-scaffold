Rails.application.routes.draw do

  post 'friendships/create'
  root 'posts#index'
  get 'posts/show'

  devise_for :users

  resources :users, only: [:index, :show] do
    member do 
      post :confirm
      delete :destroy
    end
  end

  resources :posts, only: [:index, :show, :create] do
    resources :comments, only: [:index, :create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
