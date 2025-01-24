Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  get 'pages/index'
  get 'profile', to: 'users#edit', as: 'profile'

  # Route to handle profile updates (PATCH request)
  patch 'profile', to: 'users#update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
