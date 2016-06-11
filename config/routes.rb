Rails.application.routes.draw do
  root to: 'dashboard#index'
  resources :dashboard, only: [:index]
end
