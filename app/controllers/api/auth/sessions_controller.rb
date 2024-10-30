# frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  # Custom response for successful login
  def respond_with(resource, _opts = {})
    render json: {
      status: {
        code: 200,
        message: "Logged in successfully.",
        data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  # Custom response for failed login
  def respond_to_on_failure
    render json: {
      status: {
        code: 401,
        message: "Invalid email or password."
      }
    }, status: :unauthorized
  end

  # Custom response for logout
  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      begin
        jwt_payload = JWT.decode(
          request.headers["Authorization"].split(" ").last,
          Rails.application.credentials.devise_jwt_secret_key!,
          true, { algorithm: "HS256" }
        ).first
        current_user = User.find(jwt_payload["sub"])

        render json: {
          status: 200,
          message: "Logged out successfully."
        }, status: :ok

      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: {
          status: 401,
          message: "Invalid token or no active session found."
        }, status: :unauthorized
      end
    else
      render json: {
        status: 401,
        message: "Authorization token missing. Couldn't log out."
      }, status: :unauthorized
    end
  end
end
