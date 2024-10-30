Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :accounts do
    resources :transactions, only: [ :create, :index ]
  end

  post "accounts/:id/deposit", to: "transactions#deposit"
  post "accounts/:id/withdraw", to: "transactions#withdraw"
  post "accounts/transfer", to: "transactions#transfer"
end
