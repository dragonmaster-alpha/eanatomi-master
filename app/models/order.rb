class Order < ActiveRecord::Base
  include HasZipAndCity

  searchkick(
    :callbacks   => (Rails.env.production? ? :queue : false),
    :batch_size  => 200,
    settings: { number_of_shards: 1, number_of_replicas: 1 }
  )

  before_create :set_rate_and_vat
  before_validation :clean_vat

  has_many :order_items, dependent: :destroy
  has_many :shipping_events, dependent: :destroy
  has_one :invoice, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :logs, dependent: :destroy, class_name: 'OrderLog'
  belongs_to :user, optional: true
  has_one :gift_card_transaction
  belongs_to :gift_card, optional: true
  has_many :shipments
  belongs_to :voucher, optional: true
  has_many :voucher_lines, through: :voucher, source: :lines
  has_many :failures

  default_scope -> { order(placed_at: :desc, created_at: :desc) }
  scope :unseen_failures, -> { where(id: Order.joins(:failures).merge(Failure.unseen)) }
  scope :needs_review, -> { where(status: [:placed, :pending_payment]).where(needs_review: true).where(is_reviewed: [nil, false]) }
  scope :unshipped, -> { where(status: [:placed, :received, :ready_to_pick, :picking_started]) }


  enum status: {
    open: 0,
    placed: 1,
    received: 2,
    ready_to_pick: 3,
    picking_started: 4,
    shipped_complete: 5,
    shipped_incomplete: 6,
    abandoned: 9,
    cancelled: 10,
    pending_payment: 11,
    template: 20
  }

  def self.number(order_number)
    find_by(order_number: OrderNumber.new(order_number).to_s)
  end

  def can_edit?
    !shipped_complete?
  end

  def invoice_address
    Address.new(name: name, att: att, street: address, zip_code: zip_code, city: city, country: country, country_code: country_code)
  end

  def shipping_address
    if delivery_name.present?
      Address.new(name: delivery_name, att: delivery_att, street: delivery_address, zip_code: delivery_zip_code, city: delivery_city, country: delivery_country, country_code: delivery_country_code)
    else
      invoice_address
    end
  end

  def servicepoint_address
    if servicepoint?
      Address.new(name: servicepoint_name, att: shipping_address.name, street: servicepoint_street, zip_code: servicepoint_zip_code, city: servicepoint_city, country_code: servicepoint_country_code, code: servicepoint_id)
    end
  end

  def in_stock?
    !order_items.map(&:in_stock?).include?(false)
  end

  def out_of_stock?
    !in_stock?
  end

  def delivery?
    true
  end

  def accounting_class
    super ? super.constantize : market.accounting_class
  end

  def warehouse
    super || Rails.application.warehouse
  end

  def vat?
    vat.to_f > 0
  end

  def gross_price
    order_items.map(&:gross_amount).inject(&:+) || 0
  end

  def net_price
    order_items.map(&:net_amount).inject(&:+) || 0
  end

  def gross_amount
    gross_price + delivery_gross_amount + clearance_gross_amount - gift_card_gross_amount
  end

  def net_amount
    net_price + delivery_net_amount + clearance_net_amount - gift_card_net_amount
  end

  def delivery_gross_amount
    Currency.new(delivery_fee, rate, vat).gross_amount
  end

  def delivery_net_amount
    Currency.new(delivery_fee, rate, vat).net_amount
  end

  def clearance_gross_amount
    Currency.new(clearance_fee, rate, vat).gross_amount
  end

  def clearance_net_amount
    Currency.new(clearance_fee, rate, vat).net_amount
  end

  def vat_amount
    net_amount - gross_amount
  end

  def net_amount_in_cents
    (net_amount * 100).to_i
  end

  def gift_card_net_amount
    gift_card_transaction.net_amount || (gift_card.net_available > net_price ? net_price : gift_card.net_available)
  end

  def gift_card_gross_amount
    Currency.calculate_base(gift_card_net_amount, rate, vat)
  end

  def pay?
    net_amount >= 0
  end

  def lock_fees!
    self.update! delivery_fee: delivery_fee, clearance_fee: clearance_fee
  end

  def gift_card?
    gift_card.persisted?
  end

  def voucher?
    voucher.persisted?
  end

  def gift_card_transaction
    super || GiftCardTransaction.new
  end

  def gift_card
    super || GiftCard.new
  end

  def voucher
    super || Voucher.new
  end


  def log!(name)
    OrderLog.create!(name: name, order: self)
  end

  def email
    super || user&.email
  end

  def phone
    super || user&.phone
  end

  def name
    super || user&.name
  end

  def address
    super || user&.address
  end

  def zip_code
    super || user&.zip_code
  end

  def city
    super || user&.city
  end

  def att
    super || user&.att
  end

  def vat_number
    super || user&.vat_number
  end

  def vat
    is_vat_exempt ? 0 : super
  end

  def fees
     delivery_fee + clearance_fee
  end

  def delivery_fee
    super || BigDecimal(DeliveryMethod.fetch(market.key, self.delivery_method)&.cost.to_s.presence || 0)
  end

  def clearance_fee
    super || BigDecimal(market.clearance_fee.to_s.presence || 0)
  end

  def clearance_fee?
    clearance_fee > 0
  end

  def delivery_fee?
    @delivery_fee > 0
  end

  def invoice
    super || Invoice.new
  end

  def payment
    super || Payment.new
  end

  def payed_with_card?
    payment_method == 'credit_card' || payment_method == 'mobilepay'
  end

  def client_type
    super || user&.client_type || ClientType.default
  end

  def delivery_method
    super || DeliveryMethod.default(market.key).key
  end

  def courier
    super.presence || market.shipping_provider
  end

  def flex?
    self.flex_instructions.present? && ['door', 'business'].include?(self.delivery_method)
  end

  def payment_method
    super || PaymentMethod.default(market.key).id
  end

  def to_s
    order_number || super
  end

  def market
    @_market ||= begin
      Market.fetch(market_id)
    rescue Market::NotFoundError
      Market.first
    end
  end

  def needs_review?
    needs_review && !is_reviewed
  end

  def country_code
    super || market.key
  end

  def country
    Country.new(market.locale).find(country_code)
  end

  def delivery_country_code
    super || country_code
  end

  def delivery_country
    Country.new(market.locale).find(delivery_country_code)
  end

  def set_rate_and_vat
    self.rate = market.rate
    self.vat = market.vat
  end

  def clean_vat
    self.vat_number&.gsub!(/\D/, '')

    if market.key == 'se' && vat_number.to_s.length == 10
      self.vat_number = "#{vat_number}01"
    end
  end

  def servicepoint?
    delivery_method == 'droppoint' && servicepoint_id.present?
  end

  def vat_number_valid?
    clean_vat
    begin
      VatCheck.new("#{market.key.upcase}#{vat_number}").valid?
    rescue Savon::HTTPError => e
      Raven.capture_exception(e)
      false
    end
  end

  def set_order_number
    self.update!(order_number: OrderNumber.next) unless self.order_number
  end

  def update_status!
    self.update! status: shipping_events.last.status if shipping_events.any?
  end

  def lock_sales_price!
    order_items.each &:lock_sales_price!
  end

  def search_data
    SearchEncoder.new.encode({
      status: status,
      order_number: order_number,
      name: name,
      att: att,
      phone: phone,
      email: email,
      address: address,
      city: city,
      delivery_name: delivery_name,
      delivery_att: delivery_att,
      delivery_address: delivery_address,
      delivery_city: delivery_city,
      net_amount: net_amount,
      order_items_name: order_items.map(&:name),
      order_items_sku: order_items.map(&:sku_code),
      reference_number: reference_number,
      placed_at: placed_at
    })
  end

end
