require 'sidekiq/web'
# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_token]
# Sidekiq::Web.set :sessions, Rails.application.config.session_options

Rails.application.routes.draw do

  constraints AdminAccess do
    mount Sidekiq::Web => '/sidekiq'
    mount Flipper::UI.app(Flipper) => '/flipper'
    mount Blazer::Engine => '/blazer'
  end

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  root to: 'home#index'

  get 'search', to: 'search#index'
  get 'search_preview', to: 'search_previews#index'
  get 'torso-comparison', to: 'static_product_comparisons#show'

  resources :gift_cards do
    get 'print'
    resources :payments, module: 'gift_cards'
  end

  resources :enquiries
  resource :subscriptions

  get 'feeds.xml', to: 'feeds#index'
  get 'feeds/google_shopping'
  get 'feeds/sitemap'

  resources :products, path: 'p' do
    resources :order_items, module: 'products'
  end

  resources :categories, path: 'c'

  resource :checkout, controller: 'checkout' do
    resource :servicepoints, module: 'checkout'
    resources :order_items, module: 'checkout'
    resources :orders, module: 'checkout' do
      resource :acceptance, module: 'orders', controller: 'acceptance'
      resource :payments, module: 'orders'
      resource :gift_cards, module: 'orders'
      resource :vouchers, module: 'orders'
      resource :share_links, module: 'orders'
      resource :duplicates, module: 'orders'
    end
  end

  resource :users

  resources :orders do
    get :payment
    resource :customs_invoices, module: 'orders'
    resource :invoices, module: 'orders'
  end

  namespace :shiphero do
    post 'webhooks/inventory_update', to: 'webhooks#inventory_update'
    post 'webhooks/shipment_update', to: 'webhooks#shipment_update'
    post 'webhooks/order_canceled', to: 'webhooks#order_canceled'
  end

  namespace :admin do
    resource :product_sales
    resource :translations
    resource :image_uploads
    resource :s3_signatures
    resource :positions
    resource :bulk, controller: 'bulk'
    resources :purchase_orders
    resources :translation_changes
    resources :featured_products
    resources :featured_categories
    resources :shipping_times
    resources :manufacturers
    resources :categories do
      resources :category_banners
      resources :category_megaimages
    end
    resources :pages do
      resources :page_banners
    end
    resources :timeline_events
    resources :users
    resources :campaigns
    resources :vouchers
    resources :notices
    resources :gift_cards
    resources :markets
    resources :delivery_methods

    resources :products do
      post :destroy_datasheet
      resources :product_photos
      resource :duplicates, module: 'products'
    end

    resources :orders do
      resources :order_items
      resource :shipments
      resources :invoices
      resource :confirmations
      resource :duplicates
      resource :cancellations
      resource :review
      resource :payments, module: 'orders'
    end

  end

  resources :categories

  resource :product_comparisons

  get '/produkter/:category/:product', to: 'legacy_url#product'
  get '/produkter/:category', to: 'legacy_url#category'

  resources :pages, path: ''


  get '*path' => 'application#not_found' if Rails.env.production?

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
