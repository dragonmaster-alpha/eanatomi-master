class Shiphero::LineItem

  def initialize(order_item)
    @order_item = order_item
  end

  def serialize
    {
      id: @order_item.id,
      sku: @order_item.sku_code,
      name: @order_item.name,
      price: @order_item.price,
      quantity: @order_item.quantity,
      barcode: @order_item.product&.barcode
    }
  end

end
