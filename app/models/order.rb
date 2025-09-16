class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :cars, through: :order_items

  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_address, presence: true
  validates :payment_method, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :order_number, presence: true, uniqueness: true

  before_validation :generate_order_number, on: :create

  def formatted_total_amount
    "€#{total_amount.to_f.round(2)}"
  end

  private

  def generate_order_number
    self.order_number = "HDC-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
