Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root route - home page
  root "home#index"

  # Car routes
  get "car", to: "cars#show", as: :car

  # Cart routes
  get "cart", to: "cart#show", as: :cart
  post "cart/add", to: "cart#add_item", as: :add_to_cart
  delete "cart/remove/:id", to: "cart#remove_item", as: :remove_from_cart
  patch "cart/update/:id", to: "cart#update_quantity", as: :update_cart_quantity

  # Checkout routes
  get "checkout", to: "checkout#show", as: :checkout
  post "checkout", to: "checkout#create", as: :create_order

  # Order routes
  get "orders/processing", to: "orders#processing", as: :processing_order
  get "orders/:id", to: "orders#show", as: :order
end
