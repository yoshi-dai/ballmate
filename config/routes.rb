Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server => '/cable'
  
  root 'static_pages#top'
  get 'about', to: 'static_pages#about'
  get 'use', to: 'static_pages#use'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :user_profiles, only: %i[new create show edit update]
  resources :users, only: %i[new create index show destroy] do
    collection do
      get 'matched_users', to: 'users#matched_users', as: 'matched'
      get 'requested_users', to: 'users#requested_users', as: 'requested'
      get 'approval_pending_users', to: 'users#approval_pending_users', as: 'approval_pending'
      get 'matching_having_users', to: 'users#matching_having_users', as: 'matching_having'
    end
  end

  resources :chat_requests, only: [:create]

  patch:cancel_chat_request, to: 'chat_requests#cancel', as: 'cancel_chat_request'
  patch :approve_chat_request, to: 'chat_requests#approve', as: 'approve_chat_request'
  patch :reject_chat_request, to: 'chat_requests#reject', as: 'reject_chat_request'

  resources :matchings, only: %i[index show edit update] do
    collection do
      get 'matched_matchings', to: 'matchings#matched_matchings', as: 'matched'
      get 'requested_matchings', to: 'matchings#requested_matchings', as: 'requested'
      get 'approval_pending_matchings', to: 'matchings#approval_pending_matchings', as: 'approval_pending'
    end
  end

  resources :matching_profiles, only: %i[new create show edit update destroy] do
    post 'update_public_flag', on: :member
  end

  resources :groups, only: %i[new create] do
    post 'leave', on: :member
  end
  resources :notifications, only: :index
end
