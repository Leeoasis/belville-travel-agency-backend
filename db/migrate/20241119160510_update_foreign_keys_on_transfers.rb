class UpdateForeignKeysOnTransfers < ActiveRecord::Migration[7.2]
  def change
    # Remove existing foreign keys
    remove_foreign_key :transfers, column: :from_account_id
    remove_foreign_key :transfers, column: :to_account_id

    # Add new foreign keys with on_delete cascade
    add_foreign_key :transfers, :accounts, column: :from_account_id, on_delete: :cascade
    add_foreign_key :transfers, :accounts, column: :to_account_id, on_delete: :cascade
  end
end
