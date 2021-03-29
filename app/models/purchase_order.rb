class PurchaseOrder < ApplicationRecord
  belongs_to :manufacturer
  has_many :items, class_name: 'PurchaseOrderItem'

  enum status: {
    created: 0,
    sent: 1,
    fulfilled: 2,
    canceled: 3,
    future: 5
  }

  scope :pending, -> { where(status: [0, 1]) }

  def self.build(manufacturer)
    order = self.new(manufacturer: manufacturer, status: :created)
    products = manufacturer.products.select do |product|
      product.should_restock?
    end
    order.items = products.map do |product|
      PurchaseOrderItem.new(product: product, quantity: product.purchase_order_amount)
    end

    order
  end

  def pending?
    created? || sent?
  end

end
