class Transaction < ApplicationRecord
  belongs_to :account

  after_create :update_account_balance

  validates :amount, numericality: { greater_than: 0 }
  validates :date, presence: true
  validate :sufficient_balance_for_withdrawal, if: :withdrawal?

  private

  def update_account_balance
    if transaction_type == "deposit"
      account.update!(balance: account.balance + amount)
    elsif transaction_type == "withdraw"
      account.update!(balance: account.balance - amount)
    end
  end

  def sufficient_balance_for_withdrawal
    if account.balance < amount
      errors.add(:amount, "exceeds available balance")
    end
  end

  def withdrawal?
    transaction_type == "withdraw"
  end
end
