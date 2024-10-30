class Api::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    transaction = current_user.accounts.find(params[:account_id]).transactions.new(transaction_params)
    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  def index
    transactions = current_user.accounts.flat_map(&:transactions)
    render json: transactions
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :date)
  end
end
