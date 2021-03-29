class Accounting::Base::InvoiceItem
  attr_accessor :description, :sku, :quantity, :price, :invoice, :product_id

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def save!
    raise NotImplementedError
  end

  def self.build(order_item)
    self.new(
      :description  => order_item.name,
      :sku          => order_item.sku_code,
      :quantity     => order_item.quantity,
      :price        => order_item.gross_price
    )
  end

  def self.build_items(order)
    items = order.order_items.map do |order_item|
      self.build(order_item)
    end

    items << delivery_fee_item(order)
    items << clearance_fee_item(order) if order.clearance_fee?
    items << gift_card_item(order) if order.gift_card?

    items
  end

  def self.gift_card_item(order)
    description = I18n.t('activerecord.attributes.order.gift_card', locale: order.market.locale)
    self.new(description: description, sku: order.market.gift_card_sku, quantity: 1, price: -order.gift_card_gross_amount)
  end

  def self.delivery_fee_item(order)
    description = I18n.t('activerecord.attributes.order.delivery_fee', locale: order.market.locale)
    self.new(description: description, sku: order.market.delivery_sku, quantity: 1, price: order.delivery_gross_amount)
  end

  def self.clearance_fee_item(order)
    description = I18n.t('activerecord.attributes.order.clearance_fee', locale: order.market.locale)
    self.new(description: description, sku: order.market.clearance_sku, quantity: 1, price: order.clearance_gross_amount)
  end

end
