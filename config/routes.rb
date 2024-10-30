Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "api/auth/sessions",       # Points to the sessions controller in the api/auth folder
    registrations: "api/auth/registrations"  # Points to the registrations controller in the api/auth folder
  }

  namespace :api do
    resources :accounts
    resources :transactions, only: [ :index, :create ]
    post "/deposit", to: "transactions#deposit"
    post "/withdraw", to: "transactions#withdraw"
    post "/transfer", to: "transactions#transfer"
  end
end
