class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :account_name
      t.decimal :balance

      t.timestamps
    end
  end
end
