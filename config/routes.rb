Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :user_profiles
  resources :users, only: %i[new create index show]

  get 'matched_users', to: 'users#matched_users', as: 'matched_users'
  get 'requested_users', to: 'users#requested_users', as: 'requested_users'
  get 'approval_pending_users', to: 'users#approval_pending_users', as: 'approval_pending_users'

  resources :chat_requests, only: [:create] do
    patch 'approve', on: :collection
    patch 'cancel', on: :collection
    patch 'reject', on: :collection
  end

  resources :matchings 

  get 'matched_matchings', to: 'matchings#matched_matchings', as: 'matched_matchings'
  get 'requested_matchings', to: 'matchings#requested_matchings', as: 'requested_matchings'
  get 'approval_pending_matchings', to: 'matchings#approval_pending_matchings', as: 'approval_pending_matchings'

  resources :matching_profiles

  resources :groups, only: %i[new create edit update destroy]

end
