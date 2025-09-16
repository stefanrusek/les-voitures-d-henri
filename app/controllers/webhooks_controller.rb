class WebhooksController < ApplicationController
  # Skip CSRF protection for webhook endpoints
  skip_before_action :verify_authenticity_token, only: [:dolly_delivery_status]

  def dolly_delivery_status
    begin
      # Parse the webhook payload
      payload = JSON.parse(request.body.read)

      # Log the webhook for debugging
      Rails.logger.info "Received Dolly webhook: #{payload.inspect}"

      # Find the order by Dolly order ID
      dolly_order_id = payload['id']
      order = Order.find_by(dolly_order_id: dolly_order_id)

      if order.nil?
        Rails.logger.error "Order not found for Dolly order ID: #{dolly_order_id}"
        render json: { error: 'Order not found' }, status: :not_found
        return
      end

      # Update the order with the new status
      old_status = order.delivery_status
      new_status = payload['status']

      update_attributes = {
        delivery_status: new_status
      }

      # Add additional information based on the status
      case new_status
      when 'CONFIRMED'
        if payload['courier']
          courier_info = payload['courier']
          update_attributes[:delivery_tracking_url] = "Livreur: #{courier_info['fullName']} - #{courier_info['maskedPhoneNumber']}"
        end
      when 'DELIVERED'
        if payload['dropOffVerification'] && payload['dropOffVerification']['deliveryProofImageUrl']
          update_attributes[:delivery_tracking_url] = payload['dropOffVerification']['deliveryProofImageUrl']
        end
      when 'CANCELLED'
        if payload['cancelReasonCode']
          update_attributes[:delivery_error_message] = "Annulé: #{payload['cancelReasonCode']}"
        end
      when 'RETURNED'
        if payload['returnReasonCode']
          update_attributes[:delivery_error_message] = "Retourné: #{payload['returnReasonCode']}"
        end
      end

      # Update the order
      order.update!(update_attributes)

      Rails.logger.info "Updated order #{order.order_number} delivery status from #{old_status} to #{new_status}"

      # Respond with success
      render json: { status: 'success', message: 'Webhook processed successfully' }, status: :ok

    rescue JSON::ParserError => e
      Rails.logger.error "Invalid JSON in Dolly webhook: #{e.message}"
      render json: { error: 'Invalid JSON' }, status: :bad_request

    rescue => e
      Rails.logger.error "Error processing Dolly webhook: #{e.message}"
      render json: { error: 'Internal server error' }, status: :internal_server_error
    end
  end
end
