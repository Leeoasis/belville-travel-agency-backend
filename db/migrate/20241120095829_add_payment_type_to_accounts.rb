class AddPaymentTypeToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :payment_type, :string
  end
end
