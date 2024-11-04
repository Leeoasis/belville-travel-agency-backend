Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"
  namespace :api do
    resources :accounts
    resources :transactions, only: [ :index, :create ] do
      collection do
        post :deposit
        post :withdraw
      end
    end
    resources :transfers, only: [ :create ]
  end
end
