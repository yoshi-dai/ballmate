Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :user_profiles
  resources :users
  resources :chat_requests, only: [:create] do
    patch 'approve', on: :collection
  end
end
