class Car < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :color, presence: true
  validates :image_url, presence: true

  def formatted_price
    "€#{price.to_f.round(2)}"
  end
end
