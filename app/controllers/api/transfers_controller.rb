class Api::TransfersController < ApplicationController
  def index
    transfers = Transfer.includes(:from_account, :to_account).all
    transfers_with_account_names = transfers.map do |transfer|
      transfer.attributes.merge(
        from_account_name: transfer.from_account.account_name,
        to_account_name: transfer.to_account.account_name
      )
    end
    render json: transfers_with_account_names
  end
  # Create a new transfer
  def create
    from_account = Account.find_by(account_name: params[:from_account_name])
    to_account = Account.find_by(account_name: params[:to_account_name])

    if from_account.nil? || to_account.nil?
      render json: { error: "One or both accounts not found" }, status: :not_found
      return
    end

    if from_account.balance >= params[:amount].to_d
      ActiveRecord::Base.transaction do
        from_account.update!(balance: from_account.balance - params[:amount].to_d)
        to_account.update!(balance: to_account.balance + params[:amount].to_d)

        transfer = Transfer.create!(from_account: from_account, to_account: to_account, amount: params[:amount], date: Time.current)
        render json: { message: "Transfer successful", transfer: transfer }, status: :ok
      end
    else
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
