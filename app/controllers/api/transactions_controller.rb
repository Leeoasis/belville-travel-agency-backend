class Api::TransactionsController < ApplicationController
  include RackSessionsFix
  before_action :authenticate_user!

  # Fetch all transactions
  def index
    transactions = current_user.accounts.flat_map(&:transactions)
    render json: transactions
  end

  # Create a new transaction (general action, could be used for deposits and withdrawals)
  def create
    transaction = current_user.accounts.find(params[:account_id]).transactions.new(transaction_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a deposit
  def deposit
    transaction = current_user.accounts.find(params[:account_id]).transactions.new(transaction_params.merge(transaction_type: "deposit"))

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a withdrawal
  def withdraw
    transaction = current_user.accounts.find(params[:account_id]).transactions.new(transaction_params.merge(transaction_type: "withdraw"))

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for transactions
  def transaction_params
    params.require(:transaction).permit(:amount, :date) # Ensure to permit any other necessary fields
  end
end
