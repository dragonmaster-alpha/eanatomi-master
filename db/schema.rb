# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_21_020854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_in_markets", id: :serial, force: :cascade do |t|
    t.boolean "dk"
    t.boolean "se"
    t.boolean "no"
    t.boolean "gl"
    t.boolean "fo"
    t.boolean "is"
    t.boolean "fi"
    t.string "activatable_type"
    t.integer "activatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "local_no"
    t.boolean "de"
    t.boolean "com"
    t.index ["activatable_type", "activatable_id"], name: "index_active_in_markets_on_activatable_type_and_activatable_id"
    t.index ["dk"], name: "index_active_in_markets_on_dk"
    t.index ["fi"], name: "index_active_in_markets_on_fi"
    t.index ["fo"], name: "index_active_in_markets_on_fo"
    t.index ["gl"], name: "index_active_in_markets_on_gl"
    t.index ["is"], name: "index_active_in_markets_on_is"
    t.index ["local_no"], name: "index_active_in_markets_on_local_no"
    t.index ["no"], name: "index_active_in_markets_on_no"
    t.index ["se"], name: "index_active_in_markets_on_se"
  end

  create_table "api_logs", force: :cascade do |t|
    t.string "service"
    t.string "url"
    t.string "method"
    t.string "response_code"
    t.text "response_body"
    t.text "request_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service"], name: "index_api_logs_on_service"
  end

  create_table "blazer_audits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.integer "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "campaigns", id: :serial, force: :cascade do |t|
    t.string "market_id"
    t.string "url"
    t.json "photo_data"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "imgix_photo_data"
    t.integer "status"
    t.string "placement"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.integer "category_id"
    t.integer "position"
    t.integer "status"
    t.hstore "name_translations"
    t.json "photo_data"
    t.hstore "meta_title_translations"
    t.hstore "meta_description_translations"
    t.hstore "slug_translations"
    t.integer "products_count"
    t.integer "categories_count"
    t.json "imgix_photo_data"
    t.string "template"
    t.hstore "body_translations"
    t.hstore "extended_body_translations"
    t.boolean "is_inline"
    t.integer "regular_categories_count"
    t.json "imgix_icon_data"
    t.string "megamenu_type"
  end

  create_table "category_banners", force: :cascade do |t|
    t.json "photo_data"
    t.bigint "category_id"
    t.integer "position"
    t.json "imgix_photo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_banners_on_category_id"
  end

  create_table "category_megaimages", force: :cascade do |t|
    t.json "photodata"
    t.bigint "category_id"
    t.integer "position"
    t.json "imgix_photo_data"
    t.text "mega_type"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_megaimages_on_category_id"
  end

  create_table "complementary_products", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.integer "target_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_methods", force: :cascade do |t|
    t.bigint "market_id"
    t.string "key"
    t.decimal "cost"
    t.string "availability", array: true
    t.string "couriers", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["market_id"], name: "index_delivery_methods_on_market_id"
  end

  create_table "enquiries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.boolean "call_me"
    t.string "url"
  end

  create_table "failures", id: :serial, force: :cascade do |t|
    t.string "exception"
    t.string "message"
    t.uuid "order_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "context"
    t.index ["order_id"], name: "index_failures_on_order_id"
  end

  create_table "featured_categories", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_featured_categories_on_category_id"
  end

  create_table "featured_products", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_featured_products_on_product_id"
  end

  create_table "gift_card_transactions", id: :serial, force: :cascade do |t|
    t.uuid "gift_card_id"
    t.uuid "order_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "net_amount"
  end

  create_table "gift_cards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.decimal "net_amount"
    t.decimal "vat"
    t.decimal "rate"
    t.string "market_id"
    t.integer "status"
    t.string "payment_id"
    t.string "invoice_id"
    t.string "code"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_number"
    t.string "recipient"
    t.decimal "gross_amount"
    t.text "message"
    t.json "invoice_file_data"
    t.json "file_data"
    t.string "accounting_class"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.integer "status"
    t.json "file_data"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "gift_card_id"
    t.index ["gift_card_id"], name: "index_invoices_on_gift_card_id"
    t.index ["order_id"], name: "index_invoices_on_order_id"
  end

  create_table "legacy_urls", id: :serial, force: :cascade do |t|
    t.string "kind"
    t.string "path"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_legacy_urls_on_path"
  end

  create_table "manufacturers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.integer "restocking_interval"
    t.date "last_purchase_order_on"
    t.string "attention"
  end

  create_table "markets", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "locale"
    t.string "currency"
    t.string "country"
    t.string "country_code"
    t.string "domain"
    t.string "timezone"
    t.decimal "rate"
    t.decimal "vat"
    t.decimal "clearance_fee"
    t.string "analytics_id"
    t.string "delivery_sku"
    t.string "gift_card_sku"
    t.string "delivery_id"
    t.string "gift_card_id"
    t.boolean "customs_invoice"
    t.string "google_site_verification"
    t.string "google_merchant_id"
    t.string "phone_prefix"
    t.boolean "free_shipping"
    t.boolean "eu"
    t.boolean "active"
    t.string "accounting_class"
    t.string "shipping_provider"
    t.string "couriers", array: true
    t.boolean "choose_servicepoint"
    t.boolean "notice"
    t.string "blog_url"
    t.string "warehouse"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "development_url"
    t.string "facebook_pixel_id"
    t.string "epay_md5_key"
    t.string "epay_merchant_number"
    t.boolean "require_vat_number"
    t.integer "position"
    t.index ["domain"], name: "index_markets_on_domain"
    t.index ["key"], name: "index_markets_on_key"
  end

  create_table "notices", id: :serial, force: :cascade do |t|
    t.hstore "text_translations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "quantity"
    t.string "sku_code"
    t.string "ean_number"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.integer "position"
    t.boolean "has_discount"
    t.decimal "sales_price"
    t.boolean "in_stock_cache"
    t.integer "component_ids", array: true
  end

  create_table "order_logs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_logs_on_order_id"
  end

  create_table "orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "country"
    t.string "vat_number"
    t.string "delivery_name"
    t.string "delivery_address"
    t.string "delivery_zip_code"
    t.string "delivery_city"
    t.string "delivery_country"
    t.string "payment_method"
    t.string "client_type"
    t.integer "status"
    t.string "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "placed_at"
    t.string "invoice_id"
    t.string "session_id"
    t.string "delivery_method"
    t.string "market_id"
    t.decimal "rate"
    t.decimal "vat"
    t.string "att"
    t.string "ean_number"
    t.string "reference_number"
    t.string "flex_instructions"
    t.string "payment_id"
    t.datetime "shipped_at"
    t.json "invoice_data"
    t.string "address2"
    t.string "delivery_address2"
    t.string "delivery_att"
    t.boolean "needs_confirmation"
    t.decimal "clearance_fee"
    t.decimal "delivery_fee"
    t.integer "user_id"
    t.uuid "gift_card_id"
    t.integer "waiting_notice"
    t.boolean "is_reviewed"
    t.integer "voucher_id"
    t.boolean "is_invoiced", default: true
    t.string "delivery_country_code"
    t.string "country_code"
    t.boolean "is_subscribing"
    t.string "accounting_class"
    t.boolean "needs_review"
    t.boolean "is_vat_exempt"
    t.string "servicepoint_id"
    t.string "servicepoint_name"
    t.string "servicepoint_street"
    t.string "servicepoint_zip_code"
    t.string "servicepoint_city"
    t.string "servicepoint_country_code"
    t.string "courier"
    t.string "payment_link"
    t.string "warehouse_id"
    t.string "warehouse"
    t.index ["session_id"], name: "index_orders_on_session_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["voucher_id"], name: "index_orders_on_voucher_id"
  end

  create_table "page_banners", force: :cascade do |t|
    t.json "photo_data"
    t.bigint "page_id"
    t.integer "position"
    t.json "imgix_photo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_banners_on_page_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.hstore "name_translations"
    t.hstore "meta_title_translations"
    t.hstore "meta_description_translations"
    t.hstore "body_translations"
    t.integer "template"
    t.boolean "in_top"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "slug_translations"
    t.string "placement"
    t.integer "page_id"
    t.boolean "is_active"
    t.index ["page_id"], name: "index_pages_on_page_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.integer "status"
    t.decimal "authorized_amount"
    t.decimal "captured_amount"
    t.string "currency"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "product_addons", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.integer "addon_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_product_addons_on_addon_id"
    t.index ["owner_id"], name: "index_product_addons_on_owner_id"
  end

  create_table "product_components", force: :cascade do |t|
    t.integer "component_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_product_components_on_component_id"
    t.index ["owner_id"], name: "index_product_components_on_owner_id"
  end

  create_table "product_descriptions", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "position"
    t.hstore "body_translations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

  create_table "product_photos", id: :serial, force: :cascade do |t|
    t.json "photo_data"
    t.integer "product_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "imgix_photo_data"
    t.index ["product_id"], name: "index_product_photos_on_product_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "photo"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sku"
    t.integer "category_id"
    t.integer "position"
    t.integer "status"
    t.hstore "name_translations"
    t.hstore "description_translations"
    t.hstore "slug_translations"
    t.decimal "cost_price"
    t.decimal "offer_price"
    t.string "pdf"
    t.integer "manufacturer_id"
    t.integer "shipping_time_id"
    t.integer "stock"
    t.hstore "keywords_translations"
    t.hstore "meta_title_translations"
    t.hstore "meta_description_translations"
    t.string "size_deprecated"
    t.string "reference"
    t.json "datasheet_data"
    t.string "video"
    t.integer "sales_count"
    t.string "label_deprecated"
    t.string "tripletex_id"
    t.integer "restocking_threshold"
    t.integer "restocking_amount"
    t.hstore "label_translations"
    t.integer "product_id"
    t.integer "addon_id"
    t.hstore "size_translations"
    t.string "barcode"
    t.integer "stock_no"
    t.string "supplier_id"
    t.string "economic_id"
    t.index ["addon_id"], name: "index_products_on_addon_id"
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
    t.index ["product_id"], name: "index_products_on_product_id"
    t.index ["shipping_time_id"], name: "index_products_on_shipping_time_id"
  end

  create_table "purchase_order_items", id: :serial, force: :cascade do |t|
    t.integer "purchase_order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_order_items_on_product_id"
    t.index ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id"
  end

  create_table "purchase_orders", id: :serial, force: :cascade do |t|
    t.integer "manufacturer_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "index_purchase_orders_on_manufacturer_id"
  end

  create_table "shipments", id: :serial, force: :cascade do |t|
    t.string "status"
    t.string "code"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "distributor"
    t.index ["order_id"], name: "index_shipments_on_order_id"
  end

  create_table "shipping_events", id: :serial, force: :cascade do |t|
    t.datetime "occurred_at"
    t.integer "status"
    t.integer "status_code"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipping_events_on_order_id"
  end

  create_table "shipping_times", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.hstore "description_translations"
  end

  create_table "storages", id: :serial, force: :cascade do |t|
    t.json "file_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeline_events", id: :serial, force: :cascade do |t|
    t.hstore "title_translations"
    t.json "photo_data"
    t.hstore "body_translations"
    t.datetime "occurred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.json "imgix_photo_data"
    t.text "slider_type"
  end

  create_table "translation_changes", id: :serial, force: :cascade do |t|
    t.integer "object_id"
    t.text "object_type"
    t.integer "user_id"
    t.string "field"
    t.text "changed_from"
    t.text "changed_to"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_id"], name: "index_translation_changes_on_object_id"
    t.index ["object_type"], name: "index_translation_changes_on_object_type"
    t.index ["user_id"], name: "index_translation_changes_on_user_id"
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "name"
    t.integer "role"
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "client_type"
    t.string "phone"
    t.string "att"
    t.string "vat_number"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "market_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "vendor_prices", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "user_id"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount"
    t.index ["product_id"], name: "index_vendor_prices_on_product_id"
    t.index ["user_id"], name: "index_vendor_prices_on_user_id"
  end

  create_table "volume_prices", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_volume_prices_on_product_id"
  end

  create_table "voucher_lines", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.decimal "price"
    t.integer "voucher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voucher_id"], name: "index_voucher_lines_on_voucher_id"
  end

  create_table "vouchers", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "category_banners", "categories"
  add_foreign_key "category_megaimages", "categories"
  add_foreign_key "delivery_methods", "markets"
  add_foreign_key "failures", "orders"
  add_foreign_key "featured_categories", "categories"
  add_foreign_key "featured_products", "products"
  add_foreign_key "invoices", "gift_cards"
  add_foreign_key "invoices", "orders"
  add_foreign_key "order_logs", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "vouchers"
  add_foreign_key "page_banners", "pages"
  add_foreign_key "pages", "pages"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_descriptions", "products"
  add_foreign_key "product_photos", "products"
  add_foreign_key "products", "products"
  add_foreign_key "purchase_order_items", "products"
  add_foreign_key "purchase_order_items", "purchase_orders"
  add_foreign_key "shipments", "orders"
  add_foreign_key "shipping_events", "orders"
  add_foreign_key "translation_changes", "users"
  add_foreign_key "vendor_prices", "products"
  add_foreign_key "vendor_prices", "users"
  add_foreign_key "volume_prices", "products"
  add_foreign_key "voucher_lines", "vouchers"
end
