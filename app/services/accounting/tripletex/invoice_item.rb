class Accounting::Tripletex::InvoiceItem < Accounting::Base::InvoiceItem

  def save!
    Accounting::Tripletex::Client.new.post('order/orderline', self.serialize)
    self
  end

  def serialize
    {
      order: {
        id: @invoice.id
      },
      description: @description,
      count: @quantity,
      unitPriceExcludingVatCurrency: @price,
      vatType: {
        id: 3
      },
      product: {
        id: @product_id
      }
    }
  end

  def self.build(order_item)
    super.tap do |item|
      item.product_id = order_item.product.tripletex_id
    end
  end

  def self.delivery_fee_item(order)
    super.tap do |item|
      item.product_id = order.market.delivery_id
    end
  end

  def self.gift_card_item(order)
    super.tap do |item|
      item.product_id = order.market.gift_card_id
    end
  end

  def self.clearance_fee_item(order)
    super.tap do |item|
      item.product_id = order.market.clearance_fee_id
    end
  end


end
