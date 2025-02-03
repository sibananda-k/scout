Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  get '/accept_invitation/:invitation_token', to: 'users#accept_invitation', as: :accept_invitation

  resources :users, only: [:index, :show, :update, :destroy]
  post 'change_organisation', to: 'pages#change_organisation', as: 'change_organisation'
  root 'pages#index'
  get 'pages/index'
  get 'profile', to: 'users#edit', as: 'profile'
  patch 'profile', to: 'users#update'
  resource :invitations, only: [:new, :create]
  get 'invitations/new', to: 'invitations#new', as: :new_invitation
  post 'invitations', to: 'invitations#create', as: :send_invitation
  # For password change page and action
  get 'user/change_password', to: 'users#change_password', as: 'change_user_password'
  patch 'user/update_password', to: 'users#update_password', as: 'update_user_password'
end
