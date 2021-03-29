class Context::Cart

  def initialize(session_id, market_id, user)
    @session_id = session_id
    @market_id = market_id
    @user = user
  end

  def order
    @_order ||= begin
      order = Order.where.not(session_id: nil).find_or_initialize_by(session_id: @session_id, market_id: @market_id, status: 0)
      order.user = @user
      order
    end
  end

  def add(product, quantity, price=nil)
    item = order.order_items.find_by(sku_code: product.sku) || OrderItemFromProduct.new(product, price).order_item
    item.quantity = item.quantity.to_i + quantity.to_i
    item.order = order

    item.save
    item
  end

  def items
    order.order_items
  end

  def size
    items.size
  end

  def empty?
    order.order_items.empty?
  end

end
