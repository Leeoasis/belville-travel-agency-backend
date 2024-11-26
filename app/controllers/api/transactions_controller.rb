class Api::TransactionsController < ApplicationController
  # Fetch all transactions
  def index
    if params[:account_id].present?
      account = Account.find_by(id: params[:account_id])
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
    account = Account.find_by(id: params[:account_id])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params)
    transaction.account = account

    if transaction.save
      render json: { message: "Transaction created successfully" }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a deposit
  def deposit
    if params[:account_id].blank?
      render json: { error: "Account ID cannot be blank" }, status: :unprocessable_entity
      return
    end

    account = Account.find_by(id: params[:account_id])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params.merge(transaction_type: "deposit"))
    transaction.account = account

    if transaction.save
      account.update!(balance: account.balance + transaction.amount)
      render json: { message: "Deposit created successfully" }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  # Make a withdrawal
  def withdraw
    if params[:account_id].blank?
      render json: { error: "Account ID cannot be blank" }, status: :unprocessable_entity
      return
    end

    account = Account.find_by(id: params[:account_id])
    if account.nil?
      render json: { error: "Account not found" }, status: :not_found
      return
    end

    transaction = Transaction.new(transaction_params.merge(transaction_type: "withdraw"))
    transaction.account = account

    if account.balance >= transaction.amount
      if transaction.save
        account.update!(balance: account.balance - transaction.amount)
        render json: { message: "Withdrawal created successfully" }, status: :created
      else
        render json: transaction.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for transactions
  def transaction_params
    params.require(:transaction).permit(:amount, :date, :transaction_type)
  end
end
