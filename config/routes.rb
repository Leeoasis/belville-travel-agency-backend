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
    resources :transfers, only: [ :index, :create ]
  end
  root to: proc { [ 200, { "Content-Type" => "application/json" }, [ '{"message":"API is running"}' ] ] }
end
