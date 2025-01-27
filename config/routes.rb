Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  get 'pages/index'
  get 'profile', to: 'users#edit', as: 'profile'

  # Route to handle profile updates (PATCH request)
  patch 'profile', to: 'users#update'
  
  # For password change page and action
  get 'user/change_password', to: 'users#change_password', as: 'change_user_password'
  patch 'user/update_password', to: 'users#update_password', as: 'update_user_password'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
