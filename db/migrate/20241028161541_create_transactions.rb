class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount
      t.string :transaction_type
      t.datetime :date

      t.timestamps
    end
  end
end
