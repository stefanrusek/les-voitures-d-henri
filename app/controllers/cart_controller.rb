class CartController < ApplicationController
  def show
    @cart_items = current_cart_items.includes(:car)
    @total = cart_total
  end

  def add_item
    @car = Car.find(params[:car_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    cart_item = current_cart_items.find_by(car: @car)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + quantity)
    else
      current_cart_items.create(car: @car, quantity: quantity, session_id: session[:cart_id])
    end

    redirect_to cart_path, notice: "#{@car.name} ajouté au panier!"
  end

  def remove_item
    cart_item = current_cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Article retiré du panier."
  end

  def update_quantity
    cart_item = current_cart_items.find(params[:id])
    new_quantity = params[:quantity].to_i

    if new_quantity > 0
      cart_item.update(quantity: new_quantity)
      redirect_to cart_path, notice: "Quantité mise à jour."
    else
      cart_item.destroy
      redirect_to cart_path, notice: "Article retiré du panier."
    end
  end
end
