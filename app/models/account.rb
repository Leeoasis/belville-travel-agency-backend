class Account < ApplicationRecord
  # Ensure the correct association with dependent: :destroy to delete transfers when an account is deleted
  has_many :transfers_from, class_name: "Transfer", foreign_key: "from_account_id", dependent: :destroy
  has_many :transfers_to, class_name: "Transfer", foreign_key: "to_account_id", dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :account_name, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_type, presence: true, inclusion: { in: %w[cash card] }
end
