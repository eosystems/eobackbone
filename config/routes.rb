Rails.application.routes.draw do
  root to: 'dashboard#index'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index"

  resources :dashboard, only: [:index]

  namespace :api do
    resources :sell_orders, only: [:new, :create]
  end
end
