class Api::AccountsController < ApplicationController
  def index
    accounts = Account.all
    render json: accounts
  end

  def create
    account = Account.new(account_params)
    if account.save
      render json: account, status: :created
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def update
    account = Account.find(params[:id])
    if account.update(account_params)
      render json: account
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    account = Account.find(params[:id])
    if account.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete account" }, status: :unprocessable_entity
    end
  end

  def update
    account = Account.find(params[:id])
    if account.update(account_params)
      render json: account, status: :ok
    else
      render json: { error: "Failed to update account" }, status: :unprocessable_entity
    end
  end

  private
  def account_params
    params.permit(:account_name, :balance, :phone_number, :book_number)
  end
end
