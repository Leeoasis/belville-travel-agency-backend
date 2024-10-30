# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  # Override the create action
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      respond_to_on_failure
    end
  rescue Devise::BadRequest, Devise::InvalidSignature => e
    respond_to_on_failure
  end

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

  protected

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end
end
