class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_name
      t.decimal :balance, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
