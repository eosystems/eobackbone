Rails.application.routes.draw do
  root to: 'dashboard#index'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index"

  resources :dashboard, only: [:index]

  namespace :api, defaults: { format: :json } do
    resources :sell_orders, only: [:index, :create]
    resources :user_market_orders, only: [:index, :show, :update]
    resources :wallet_transactions, only: [:index, :update]
    resources :orders, only: [:index, :show, :update]
    resources :trades, only: [:index]
    resources :trade_summaries, only: [:index]
    resources :trade_histories, only: [:index]
    resources :trade_history_summaries, only: [:index]
    resources :locations, only: [:index]
    resources :departments, only: [:index, :show,:create, :update, :destroy]
    resources :api_checks, only: [:index]
    resources :api_managements
    resources :audits, only: [:index]
    resources :corporations, only: [:index]
    resources :corp_wallet_journals, only: [:index]
    resources :corp_wallet_divisions, only: [:index]
  end
end
