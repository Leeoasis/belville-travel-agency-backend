class Api::TransfersController < ApplicationController
  before_action :authenticate_user!

  def create
    from_account = current_user.accounts.find_by(id: params[:from_account_id])
    to_account = current_user.accounts.find_by(id: params[:to_account_id])

    unless from_account && to_account
      render json: { error: "Account not found" }, status: :not_found and return
    end

    if from_account.balance >= params[:amount].to_d
      ActiveRecord::Base.transaction do
        from_account.update!(balance: from_account.balance - params[:amount].to_d)
        to_account.update!(balance: to_account.balance + params[:amount].to_d)

        Transfer.create!(from_account: from_account, to_account: to_account, amount: params[:amount], date: Time.current)
      end
      render json: { message: "Transfer successful" }, status: :ok
    else
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
