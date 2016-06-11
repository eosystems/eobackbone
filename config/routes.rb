Rails.application.routes.draw do
  root to: 'dashboard#index'
  resources :dashboard, only: [:index]


  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index"
end
