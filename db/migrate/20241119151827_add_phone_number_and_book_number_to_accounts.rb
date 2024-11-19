class AddPhoneNumberAndBookNumberToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :phone_number, :string
    add_column :accounts, :book_number, :string
  end
end
