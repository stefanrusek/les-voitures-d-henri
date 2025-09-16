class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.includes(:car)
  end

  def processing
    @order_id = session[:processing_order_id]

    unless @order_id
      redirect_to root_path, alert: "Aucune commande en cours de traitement."
      return
    end

    @order = Order.find(@order_id)
  end
end
