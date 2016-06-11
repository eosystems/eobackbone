Rails.application.routes.draw do
  root to: 'dashboard#index'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index"

  resources :dashboard, only: [:index]

  namespace :api, defaults: { format: :json } do
    resources :sell_orders, only: [:index, :create]
  end
end
