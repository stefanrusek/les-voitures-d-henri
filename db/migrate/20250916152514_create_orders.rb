class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_email
      t.text :customer_address
      t.string :payment_method
      t.decimal :total_amount
      t.string :status
      t.string :order_number

      t.timestamps
    end
  end
end
