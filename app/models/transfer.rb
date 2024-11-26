class Transfer < ApplicationRecord
  # Associations
  belongs_to :from_account, class_name: "Account", foreign_key: "from_account_id"
  belongs_to :to_account, class_name: "Account", foreign_key: "to_account_id"

  # Validations
  validates :amount, numericality: { greater_than: 0 }
  validates :from_account_id, :to_account_id, presence: true
end
