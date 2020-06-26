class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_transactions do |t|
      t.belongs_to :order, foreign_key: true
      t.string :payment_id

      t.timestamps
    end
  end
end
