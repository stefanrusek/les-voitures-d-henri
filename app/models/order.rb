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

  def delivery_pending?
    dolly_order_id.blank?
  end

  def delivery_scheduled?
    dolly_order_id.present?
  end

  def delivery_status_display
    case delivery_status
    when 'COURIER_REQUESTED'
      'Demande de livraison envoyée'
    when 'CONFIRMED'
      'Livreur assigné'
    when 'EN_ROUTE_TO_PICKUP'
      'En route vers le point de collecte'
    when 'ARRIVED_AT_PICKUP'
      'Arrivé au point de collecte'
    when 'PICKED_UP'
      'Collecté'
    when 'EN_ROUTE_TO_DROPOFF'
      'En route vers la livraison'
    when 'ARRIVED_AT_DROPOFF'
      'Arrivé à destination'
    when 'DELIVERED'
      'Livré'
    when 'CANCELLED'
      'Annulé'
    when 'RETURNED'
      'Retourné'
    else
      delivery_status || 'En attente'
    end
  end

  private

  def generate_order_number
    self.order_number = "HDC-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
