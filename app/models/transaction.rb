class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal] }
  validates :date, presence: true
end
