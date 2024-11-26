class ApplicationController < ActionController::API
  # before_action :set_user_by_token

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permit additional parameters for sign-up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  private
  def not_found
    render json: { error: "Not Found" }, status: :not_found
  end
end
