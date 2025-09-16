class CheckoutController < ApplicationController
  def show
    @cart_items = current_cart_items.includes(:car)
    @total = cart_total

    if @cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide!"
      return
    end

    @order = Order.new
  end

  def create
    @cart_items = current_cart_items.includes(:car)
    @total = cart_total

    if @cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide!"
      return
    end

    @order = Order.new(order_params)
    @order.total_amount = @total
    @order.status = "pending"

    if @order.save
      # Create order items from cart items
      @cart_items.each do |cart_item|
        @order.order_items.create!(
          car: cart_item.car,
          quantity: cart_item.quantity,
          price: cart_item.car.price
        )
      end

      # Clear the cart
      @cart_items.destroy_all

      # Schedule delivery with Dolly
      schedule_delivery(@order)

      # Store order ID in session for processing page
      session[:processing_order_id] = @order.id

      redirect_to processing_order_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email, :customer_address, :payment_method)
  end

  def schedule_delivery(order)
    begin
      dolly_service = DollyApiService.new
      delivery_response = dolly_service.create_delivery(order)

      # Update order with Dolly information
      order.update!(
        dolly_order_id: delivery_response['id'],
        delivery_status: 'COURIER_REQUESTED',
        delivery_scheduled_at: Time.current
      )

      Rails.logger.info "Delivery scheduled successfully for order #{order.order_number}: #{delivery_response['id']}"

    rescue => e
      Rails.logger.error "Failed to schedule delivery for order #{order.order_number}: #{e.message}"

      # Update order with error information
      order.update(
        delivery_error_message: e.message,
        delivery_status: 'FAILED'
      )

      # Don't fail the order creation, just log the error
      # In production, you might want to queue a retry job
    end
  end
end
