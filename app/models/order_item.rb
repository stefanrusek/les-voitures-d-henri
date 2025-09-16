class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :car

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def total_price
    price * quantity
  end

  def formatted_total_price
    "€#{total_price.to_f.round(2)}"
  end
end
