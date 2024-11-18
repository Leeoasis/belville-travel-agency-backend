class ApplicationController < ActionController::API
  # before_action :set_user_by_token

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_cors_headers

  protected

  # Permit additional parameters for sign-up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  private

  # # Set headers to allow frontend to access Devise Token Auth headers
  # def set_cors_headers
  #   headers["Access-Control-Expose-Headers"] = "access-token, client, uid, expiry, token-type"
  # end

  # Log headers to ensure they're being set properly
  # def set_user_by_token
  #   # Override the set_user_by_token method to prevent it from storing the user in the session
  #   user = User.find_by(uid: request.headers["uid"])
  #   if user && user.tokens[request.headers["client"]] && user.tokens[request.headers["client"]]["token"] == request.headers["access-token"]
  #     @current_user = user
  #     true
  #   else
  #     false
  #   end
  # end

  # def authenticate_request
  #   if @current_user.nil?
  #     render json: { error: "Unauthorized" }, status: :unauthorized
  #   end
  # end
end
