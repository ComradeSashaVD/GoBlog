Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      post :like
      post :dislike
      delete :unvote
    end
  end

  resources :users, only: [:show] do
    member do
      post :subscribe
      delete :unsubscribe
      get :subscribers
    end
  end

  get '/my_subscriptions', to: 'users#subscriptions', as: 'my_subscriptions'

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
    collection do
      patch :mark_all_as_read
    end
  end

  root 'posts#index'
end