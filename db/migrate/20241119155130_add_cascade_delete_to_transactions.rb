class AddCascadeDeleteToTransactions < ActiveRecord::Migration[7.2]
  def change
    # Remove the existing foreign key on the transactions table
    remove_foreign_key :transactions, :accounts

    # Add a new foreign key with `on_delete: :cascade`
    add_foreign_key :transactions, :accounts, on_delete: :cascade
  end
end
