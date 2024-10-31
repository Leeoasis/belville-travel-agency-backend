Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "api/auth/sessions",
    registrations: "api/auth/registrations"
  }
  namespace :api do
    resources :accounts
    resources :transactions, only: [ :index, :create ] do
      collection do
        post :deposit  # This would call the deposit method
        post :withdraw # This would call the withdraw method
      end
    end
    resources :transfers, only: [ :create ] # Assuming transfer has its own endpoint
  end
end
