Rails.application.routes.draw do
  root to: 'dashboard#index'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index"

  resources :dashboard, only: [:index]

  namespace :api, defaults: { format: :json } do
    resources :dashboards, only: [:index, :show]
    resources :sell_orders, only: [:index, :create]
    resources :user_market_orders, only: [:index, :show, :update]
    resources :wallet_transactions, only: [:index, :update]
    resources :orders, only: [:index, :show, :update]
    resources :buy_orders, only: [:index, :show, :create, :update, :destroy]
    resources :trades, only: [:index]
    resources :trade_summaries, only: [:index]
    resources :trade_histories, only: [:index]
    resources :trade_history_summaries, only: [:index]
    resources :locations, only: [:index]
    resources :types, only: [:index]
    resources :market_prices, only: [:show]
    resources :departments, only: [:index, :show,:create, :update, :destroy]
    resources :api_checks, only: [:index]
    resources :api_managements
    resources :corp_members, only: [:index, :destroy]
    resources :user_roles, only: [:index, :create, :destroy]
    resources :audits, only: [:index]
    resources :corporations, only: [:index]
    resources :corp_wallet_journals, only: [:index, :update]
    resources :summary_corp_wallet_journals, only: [:index]
    resources :csv_corp_wallet_journals, only: [:index]
    resources :corp_wallet_divisions, only: [:index]
    resources :ref_types, only: [:index]
    resources :my_corporations, only: [:index]
    resources :character_wallet_journals, only: [:show]
    resources :applications, only: [:index, :show, :update]
    resources :application_new_members, only: [:show, :create]
  end
end
