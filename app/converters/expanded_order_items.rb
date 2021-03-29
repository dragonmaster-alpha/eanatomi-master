class ExpandedOrderItems
  def initialize(order_items)
    @order_items = order_items
  end

  def all_items
    @order_items.map do |order_item|
      if order_item.has_components?
        order_item.components.map do |product|
          create_item(order_item, product)
        end
      else
        create_item(order_item)
      end
    end.flatten
  end

  def uniq_items
    final = []

    all_items.each do |order_item|
      if item = final.select { |i| i.sku_code == order_item.sku_code }.first
        item.quantity += order_item.quantity
      else
        final << order_item
      end
    end

    final
  end

  private

  def create_item(order_item, product=nil)
    product ||= order_item.product
    item = OrderItemFromProduct.new(product).order_item
    item.quantity = order_item.quantity
    item
  end

end