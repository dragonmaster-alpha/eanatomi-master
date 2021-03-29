class Orders::SetInStockCache
  include Interactor

  def call
    context.order.order_items.each do |order_item|
      order_item.update! in_stock_cache: !!order_item.in_stock?
    end
  end

end
