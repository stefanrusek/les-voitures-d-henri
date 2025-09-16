class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :color
      t.string :image_url

      t.timestamps
    end
  end
end
