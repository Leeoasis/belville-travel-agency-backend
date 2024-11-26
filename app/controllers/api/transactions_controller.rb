class Api::TransactionsController < ApplicationController
  # Fetch all transactions
  def index
    if params[:account_name].present?
      account = Account.find_by(account_name: params[:account_name])
      if account.nil?
        render json: { error: "Account not found" }, status: :not_found
        return
      end
      transactions = account.transactions
    else
      transactions = Transaction.includes(:account).all
    end

    transactions_with_account_name = transactions.map do |transaction|
      transaction.attributes.merge(account_name: transaction.account.account_name)
    end

    render json: transactions_with_account_name
  end


  # Create a new transaction (general action, could be used for deposits and withdrawals)
  def create
    account = Account.find_by(account_name: params[:account_name])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params.except(:account_name))
    transaction.account = account

    if transaction.save
      render json: { message: "Transaction created successfully" }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a deposit
  def deposit
    if params[:account_name].blank?
      render json: { error: "Account name cannot be blank" }, status: :unprocessable_entity
      return
    end

    account = Account.find_by(account_name: params[:account_name])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params.except(:account_name).merge(transaction_type: "deposit"))
    transaction.account = account

    if transaction.save
      render json: { message: "Deposit created successfully" }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a withdrawal
  def withdraw
    if params[:account_name].blank?
      render json: { error: "Account name cannot be blank" }, status: :unprocessable_entity
      return
    end

    account = Account.find_by(account_name: params[:account_name])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params.except(:account_name).merge(transaction_type: "withdraw"))
    transaction.account = account

    if transaction.save
      render json: { message: "Withdrawal created successfully" }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for transactions
  def transaction_params
    params.require(:transaction).permit(:amount, :date, :transaction_type).merge(account_name: params[:account_name])
  end
end
