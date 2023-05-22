Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :user_profiles
  resources :users

  get 'matched_users', to: 'users#matched_users', as: 'matched_users'
  get 'requested_users', to: 'users#requested_users', as: 'requested_users'
  get 'approval_pending_users', to: 'users#approval_pending_users', as: 'approval_pending_users'

  resources :chat_requests, only: [:create] do
    patch 'approve', on: :collection
    patch 'cancel', on: :collection
    patch 'reject', on: :collection
  end

  resources :matchings
  resources :matching_profiles
end
