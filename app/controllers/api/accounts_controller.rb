class Api::AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    accounts = current_user.accounts
    render json: accounts
  end

  def create
    account = current_user.accounts.new(account_params)
    if account.save
      render json: account, status: :created
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def update
    account = current_user.accounts.find(params[:id])
    if account.update(account_params)
      render json: account
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    account = current_user.accounts.find(params[:id])
    account.destroy
    head :no_content
  end

  private

  def account_params
    params.require(:account).permit(:account_name, :balance)
  end
end
