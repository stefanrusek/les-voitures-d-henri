# 🇫🇷 Les voitures bon marché d'Henri

> *"You can have any color you want as long as its noir"*

Welcome to the most sophisticated, elegant, and absolutely revolutionary online car dealership in the digital universe! Henri's discount cars brings you the finest French automotive experience with a touch of humor and a lot of style.

## 🚗 What is this magnificent application?

**Les voitures bon marché d'Henri** is a full-stack Ruby on Rails e-commerce application that sells exactly one car model in exactly one color (noir, naturally). But don't let the simplicity fool you - this application is packed with features that would make even the most discerning French automotive connoisseur weep tears of joy.

### ✨ Features that will change your life:

- **🏠 Landing Page**: A bombastic French-themed homepage that will transport you to the streets of Paris
- **🚙 Product Showcase**: Detailed car information with reviews so positive they border on the supernatural
- **🛒 Shopping Cart**: Because even when there's only one product, you need a cart (it's about the experience)
- **💳 Checkout Process**: Secure payment processing with a 3-second dramatic pause for effect
- **📦 Order Management**: Complete order tracking with French translations
- **🚚 Dolly Integration**: Professional delivery service integration because your car deserves a proper arrival
- **📱 Responsive Design**: Looks magnifique on any device

## 🏗️ Architecture: A Symphony of Code

This application follows the classic Rails MVC pattern with some French flair:

```
app/
├── controllers/          # The conductors of our digital orchestra
│   ├── application_controller.rb
│   ├── home_controller.rb       # Landing page magic
│   ├── cars_controller.rb       # Product showcase
│   ├── cart_controller.rb       # Shopping cart wizardry
│   ├── checkout_controller.rb   # Payment processing
│   ├── orders_controller.rb     # Order management
│   └── webhooks_controller.rb   # Dolly delivery updates
├── models/               # The business logic beauties
│   ├── car.rb           # Our magnificent automobile
│   ├── cart_item.rb     # Shopping cart items
│   ├── order.rb         # Customer orders
│   └── order_item.rb    # Individual order items
├── services/            # The behind-the-scenes heroes
│   └── dolly_api_service.rb    # Delivery integration magic
├── views/               # The visual poetry
│   ├── layouts/         # Shared header/footer
│   ├── home/           # Landing page
│   ├── cars/           # Product pages
│   ├── cart/           # Shopping cart
│   ├── checkout/       # Payment forms
│   └── orders/         # Order confirmation
└── assets/
    └── stylesheets/
        └── application.css     # French-inspired styling
```

### 🗄️ Database Schema

- **cars**: The star of the show (name, description, price, color, image_url)
- **cart_items**: Session-based shopping cart items
- **orders**: Customer orders with delivery tracking
- **order_items**: Individual items within orders

### 🔌 External Integrations

- **Dolly API**: Professional delivery service with real-time tracking
- **Auth0**: Secure authentication for API access
- **HTTParty**: Elegant HTTP client for API calls

## 🚀 Getting Started: Your Journey to Automotive Excellence

### Prerequisites

Before you can experience the magic, ensure you have:

- **Ruby 3.5.0** (or compatible version)
- **Rails 8.0.2+**
- **SQLite3** (for development)
- **Node.js** (for asset compilation)
- **A sense of humor** (essential for full appreciation)

### Installation: The Ritual

1. **Clone this masterpiece:**
   ```bash
   git clone <your-repo-url>
   cd les-voitures-dhenri
   ```

2. **Install the gems (the precious stones of Ruby):**
   ```bash
   bundle install
   ```

3. **Prepare the database (where the magic lives):**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Configure your environment secrets:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual Auth0 client secret
   ```

5. **Start the engine:**
   ```bash
   rails server -p 3001
   ```

6. **Visit the digital showroom:**
   Open your browser to `http://localhost:3001` and prepare to be amazed!

### 🔐 Environment Configuration

Create a `.env` file in the root directory:

```env
# Auth0 Configuration for Dolly API
AUTH0_CLIENT_SECRET=your_actual_auth0_client_secret_here

# Dolly API Configuration
DOLLY_API_BASE_URL=http://pg.127.0.0.1.nip.io
DOLLY_WEBHOOK_URL=http://localhost:3001/webhooks/dolly_delivery_status

# Application Configuration
RAILS_ENV=development
```

## 🛠️ Development: For the Code Artisans

### Running Tests

```bash
# Run the full test suite
rails test

# Run specific tests
rails test test/controllers/
rails test test/models/
```

### Database Operations

```bash
# Reset the database (when you need a fresh start)
rails db:drop db:create db:migrate db:seed

# Check migration status
rails db:migrate:status

# Rollback migrations (for when mistakes happen)
rails db:rollback STEP=1
```

### Console Access (The Developer's Playground)

```bash
# Access the Rails console
rails console

# Test the Dolly API service
service = DollyApiService.new
# Note: Requires valid Auth0 credentials

# Create test orders
order = Order.create!(
  customer_name: "Jean Dupont",
  customer_email: "jean@example.fr",
  customer_address: "123 Rue de la Paix\nParis, France",
  payment_method: "credit_card",
  total_amount: 25999.99,
  status: "pending"
)
```

## 🚚 Dolly Integration: Delivery Excellence

This application integrates with Dolly.com for professional car delivery services. Here's how it works:

### Delivery Flow

1. **Order Creation**: When a customer completes checkout, a Dolly delivery is automatically scheduled
2. **Status Updates**: Dolly sends webhook updates as the delivery progresses
3. **Customer Tracking**: Real-time delivery status displayed on order confirmation page
4. **French Translations**: All delivery statuses shown in elegant French

### Webhook Endpoint

The application provides a webhook endpoint for Dolly status updates:

```
POST /webhooks/dolly_delivery_status
```

### Delivery Statuses (with French translations)

- `COURIER_REQUESTED` → "Demande de livraison envoyée"
- `CONFIRMED` → "Livreur assigné"
- `EN_ROUTE_TO_PICKUP` → "En route vers le point de collecte"
- `ARRIVED_AT_PICKUP` → "Arrivé au point de collecte"
- `PICKED_UP` → "Collecté"
- `EN_ROUTE_TO_DROPOFF` → "En route vers la livraison"
- `ARRIVED_AT_DROPOFF` → "Arrivé à destination"
- `DELIVERED` → "Livré"
- `CANCELLED` → "Annulé"
- `RETURNED` → "Retourné"

### Testing Webhooks

You can test the webhook integration using curl:

```bash
curl -X POST http://localhost:3001/webhooks/dolly_delivery_status \
  -H "Content-Type: application/json" \
  -d '{
    "id": "test-dolly-order-123",
    "status": "DELIVERED",
    "dropoffVerification": {
      "deliveryProofImageUrl": "https://example.com/proof.jpg"
    }
  }'
```

## 🎨 Customization: Make It Your Own

### Styling

The application uses custom CSS with French-inspired design. Key files:

- `app/assets/stylesheets/application.css` - Main stylesheet
- Color scheme: Elegant blacks, whites, and accent colors
- Responsive design for all devices
- Print-friendly order confirmations

### Adding New Features

The application is built with extensibility in mind:

1. **New Car Models**: Extend the Car model and update the seed data
2. **Payment Methods**: Add new payment options in the checkout form
3. **Delivery Options**: Integrate additional delivery services
4. **Internationalization**: Add more languages beyond French

## 🐛 Troubleshooting: When Things Go Wrong

### Common Issues

**Server won't start:**
```bash
# Kill existing Rails processes
pkill -f "rails server"
rm -f tmp/pids/server.pid
rails server -p 3001
```

**Database issues:**
```bash
# Reset everything
rails db:drop db:create db:migrate db:seed
```

**Dolly API authentication fails:**
- Check your `.env` file has the correct `AUTH0_CLIENT_SECRET`
- Verify the Auth0 client ID in `app/services/dolly_api_service.rb`
- Ensure you have internet connectivity for Auth0 requests

**Webhook not receiving updates:**
- Verify the webhook URL is correctly configured with Dolly
- Check Rails logs for incoming webhook requests
- Ensure the webhook endpoint is accessible from external services

### Logs and Debugging

```bash
# View Rails logs
tail -f log/development.log

# Check for specific errors
grep -i error log/development.log

# Debug in Rails console
rails console
Rails.logger.level = Logger::DEBUG
```

## 🚀 Deployment: Taking It Live

### Production Considerations

1. **Environment Variables**: Set up production environment variables
2. **Database**: Use PostgreSQL or MySQL for production
3. **SSL**: Enable HTTPS for secure transactions
4. **Webhook URL**: Update Dolly webhook configuration with production URL
5. **Asset Compilation**: Precompile assets for production

### Example Production Setup

```bash
# Set production environment
export RAILS_ENV=production

# Precompile assets
rails assets:precompile

# Run migrations
rails db:migrate

# Start production server
rails server -e production -p 80
```

## 🤝 Contributing: Join the Revolution

We welcome contributions to make this application even more magnifique!

### Development Guidelines

1. **Code Style**: Follow Ruby and Rails conventions
2. **Testing**: Write tests for new features
3. **Documentation**: Update this README for significant changes
4. **French Flair**: Maintain the French theme and humor
5. **Commit Messages**: Write clear, descriptive commit messages

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Henri**: The visionary behind this automotive empire
- **Ruby on Rails**: For making web development a joy
- **Dolly.com**: For professional delivery services
- **The French**: For inspiring our sense of style and humor
- **Coffee**: The fuel that made this application possible

## 📞 Support

Having trouble? Need help? Want to share your success story?

- **Email**: henri@voitures-bon-marche.fr
- **Issues**: Open a GitHub issue
- **Documentation**: This README (you're reading it!)

---

*Remember: In the world of Henri's cars, there are no problems, only opportunities for elegant solutions.* 🇫🇷✨

**Bon voyage with your new digital car dealership!** 🚗💨
