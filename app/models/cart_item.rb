class CartItem < ApplicationRecord
  belongs_to :car

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :session_id, presence: true

  def total_price
    car.price * quantity
  end

  def formatted_total_price
    "€#{total_price.to_f.round(2)}"
  end
end
