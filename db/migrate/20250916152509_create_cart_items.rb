class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.references :car, null: false, foreign_key: true
      t.integer :quantity
      t.string :session_id

      t.timestamps
    end
  end
end
