class Api::TransfersController < ApplicationController
  # GET /api/transfers
  def index
    transfers = Transfer.includes(:from_account, :to_account).all
    transfers_with_account_details = transfers.map do |transfer|
      transfer.attributes.merge(
        from_account_name: transfer.from_account.account_name,
        to_account_name: transfer.to_account.account_name
      )
    end

    render json: transfers_with_account_details
  end

  # POST /api/transfers
  def create
    # Directly access the parameters instead of nesting under :transfer
    from_account = Account.find_by(id: params[:from_account_id])
    to_account = Account.find_by(id: params[:to_account_id])

    # Handle missing accounts
    if from_account.nil? || to_account.nil?
      render json: { error: "One or both accounts not found" }, status: :not_found
      return
    end

    # Handle insufficient balance
    if from_account.balance < params[:amount].to_d
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
      return
    end

    # Perform transfer in a transaction
    ActiveRecord::Base.transaction do
      from_account.update!(balance: from_account.balance - params[:amount].to_d)
      to_account.update!(balance: to_account.balance + params[:amount].to_d)

      transfer = Transfer.new(transfer_params)

      render json: { message: "Transfer successful", transfer: transfer }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def transfer_params
    params.require(:transfer).permit(:from_account_id, :to_account_id, :amount, :date)
  end
end
