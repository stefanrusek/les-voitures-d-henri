class DollyApiService
  include HTTParty
  
  # Use local API URL as specified
  base_uri 'http://pg.127.0.0.1.nip.io'
  
  AUTH0_DOMAIN = 'https://dev-l-7-iajb.us.auth0.com'
  AUTH0_CLIENT_ID = 'Xe4MqyMxD2pKnMG98umgpGK5yanlSBA5'
  AUTH0_AUDIENCE = 'https://papi.dolly.com'
  
  def initialize
    @access_token = nil
    @token_expires_at = nil
  end
  
  # Get Auth0 access token using client credentials flow
  def authenticate
    return @access_token if token_valid?
    
    response = HTTParty.post("#{AUTH0_DOMAIN}/oauth/token", {
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        client_id: AUTH0_CLIENT_ID,
        client_secret: Rails.application.credentials.auth0_client_secret || ENV['AUTH0_CLIENT_SECRET'],
        audience: AUTH0_AUDIENCE,
        grant_type: 'client_credentials'
      }.to_json
    })
    
    if response.success?
      token_data = response.parsed_response
      @access_token = token_data['access_token']
      @token_expires_at = Time.current + token_data['expires_in'].seconds
      @access_token
    else
      Rails.logger.error "Failed to authenticate with Auth0: #{response.body}"
      raise "Authentication failed: #{response.body}"
    end
  end
  
  # Create a delivery with Dolly
  def create_delivery(order)
    token = authenticate
    
    delivery_payload = build_delivery_payload(order)
    
    response = self.class.post('/v1/deliveries', {
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      },
      body: delivery_payload.to_json
    })
    
    if response.success?
      delivery_data = response.parsed_response
      Rails.logger.info "Dolly delivery created successfully: #{delivery_data['id']}"
      delivery_data
    else
      Rails.logger.error "Failed to create Dolly delivery: #{response.body}"
      raise "Delivery creation failed: #{response.body}"
    end
  end
  
  # Get delivery information
  def get_delivery_info(dolly_order_id)
    token = authenticate
    
    response = self.class.get("/v1/deliveries/#{dolly_order_id}", {
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    })
    
    if response.success?
      response.parsed_response
    else
      Rails.logger.error "Failed to get delivery info: #{response.body}"
      raise "Failed to get delivery info: #{response.body}"
    end
  end
  
  private
  
  def token_valid?
    @access_token.present? && @token_expires_at.present? && @token_expires_at > Time.current + 5.minutes
  end
  
  def build_delivery_payload(order)
    # Calculate delivery window (2 hours from now to 6 hours from now)
    pickup_start = 2.hours.from_now
    pickup_end = 6.hours.from_now
    delivery_start = 4.hours.from_now
    delivery_end = 8.hours.from_now
    
    # Parse customer address
    address_lines = order.customer_address.split("\n").map(&:strip)
    street_address = address_lines[0] || ""
    city_state_zip = address_lines[1] || ""
    
    # Simple parsing - in production you'd want more robust address parsing
    city = "Paris"
    state = "TX"  # Using TX as required by Dolly
    zip_code = "75001"
    
    if city_state_zip.present?
      parts = city_state_zip.split(/\s+/)
      if parts.length >= 2
        zip_code = parts.last
        city = parts[0..-2].join(" ")
      end
    end
    
    {
      batchingWorkflow: "single",
      clientId: "dollyapi",
      containsAlcohol: false,
      deliveryWindowEndTime: delivery_end.iso8601,
      deliveryWindowStartTime: delivery_start.iso8601,
      dropOffInfo: {
        dropOffAddress: {
          addressLine1: street_address,
          addressLine2: "",
          city: city,
          state: state,
          zipCode: zip_code,
          country: "US"
        },
        dropOffContact: {
          firstName: order.customer_name.split.first || order.customer_name,
          lastName: order.customer_name.split.last || "",
          phone: "1234567890"  # In production, you'd collect this from the customer
        },
        dropOffInstruction: "Livraison de voiture de luxe française. Manipuler avec précaution.",
        isUnattended: false,
        signatureRequired: true
      },
      externalDeliveryId: "#{order.order_number}_delivery",
      externalOrderId: order.order_number,
      externalStoreId: "henri-dealership-dallas",
      isAutonomousDelivery: false,
      orderInfo: build_order_info(order),
      pickupInfo: {
        pickupAddress: {
          addressLine1: "123 Automobile Avenue",
          addressLine2: "",
          city: "Dallas",
          state: "TX",
          zipCode: "75261",
          country: "US"
        },
        pickupContact: {
          firstName: "Henri",
          lastName: "Dealership",
          phone: "1234567890"
        },
        pickupInstruction: "Récupération de voiture française de luxe. Vérifier l'état avant transport.",
        signatureRequired: true
      },
      pickupWindowEndTime: pickup_end.iso8601,
      pickupWindowStartTime: pickup_start.iso8601,
      storeName: "Les voitures bon marché d'Henri",
      tip: 20.00
    }
  end
  
  def build_order_info(order)
    total_quantity = order.order_items.sum(:quantity)
    total_weight = total_quantity * 3000  # Estimate 3000 lbs per car
    
    order_line_items = order.order_items.map do |item|
      {
        name: item.car.name,
        description: item.car.description.truncate(100),
        quantity: item.quantity,
        orderedWeight: 3000,  # Weight per car in lbs
        uom: "LB",
        height: 6,    # Height in feet
        width: 8,     # Width in feet  
        length: 15,   # Length in feet
        uomDimension: "FT"
      }
    end
    
    {
      orderLineItems: order_line_items,
      totalWeight: total_weight,
      totalVolume: total_quantity * 720,  # 6 * 8 * 15 = 720 cubic feet per car
      totalQuantity: total_quantity
    }
  end
end
