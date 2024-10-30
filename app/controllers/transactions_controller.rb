class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [ :deposit, :withdraw ]

  def deposit
    @transaction = @account.transactions.build(transaction_params.merge(transaction_type: "deposit"))
    if @transaction.save
      @account.update(balance: @account.balance + @transaction.amount)
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def withdraw
    @transaction = @account.transactions.build(transaction_params.merge(transaction_type: "withdrawal"))
    if @transaction.save
      @account.update(balance: @account.balance - @transaction.amount)
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount)
  end
end
