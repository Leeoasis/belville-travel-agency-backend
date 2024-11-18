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
      transactions = Transaction.all
    end
    render json: transactions
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

  # Make a transfer
  def transfer
    from_account = Account.find_by(account_name: params[:from_account_name])
    to_account = Account.find_by(account_name: params[:to_account_name])
    if from_account.nil? || to_account.nil?
      render json: { error: "One or both accounts not found" }, status: :not_found
      return
    end

    ActiveRecord::Base.transaction do
      withdrawal = Transaction.new(transaction_params.except(:account_name).merge(transaction_type: "withdraw", account: from_account))
      deposit = Transaction.new(transaction_params.except(:account_name).merge(transaction_type: "deposit", account: to_account))

      if withdrawal.save && deposit.save
        render json: { message: "Transfer completed successfully" }, status: :created
      else
        render json: { errors: withdrawal.errors.full_messages + deposit.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  # Strong parameters for transactions
  def transaction_params
    params.require(:transaction).permit(:amount, :date, :transaction_type).merge(account_name: params[:account_name])
  end
end
