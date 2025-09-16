class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :ensure_session_id

  private

  def ensure_session_id
    session[:cart_id] ||= SecureRandom.hex(16)
  end

  def current_cart_items
    @current_cart_items ||= CartItem.where(session_id: session[:cart_id])
  end

  def cart_total
    current_cart_items.sum(&:total_price)
  end

  def cart_count
    current_cart_items.sum(:quantity)
  end

  helper_method :current_cart_items, :cart_total, :cart_count
end
