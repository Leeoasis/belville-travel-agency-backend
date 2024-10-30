# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  # Custom response for successful login
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: "Logged in successfully.",
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
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
    if current_user
      render json: { status: 200, message: "Logged out successfully." }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
