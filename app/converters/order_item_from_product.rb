class OrderItemFromProduct

  def initialize(product, price=nil)
    @product = product
    @price = price
  end

  def order_item
    item = OrderItem.new

    item.product = @product
    item.name = product_name
    item.price = @price || @product.sales_price
    item.sku_code = @product.sku
    item.ean_number = @product.ean_number
    item.has_discount = @product.offer?
    item.component_ids = @product.component_ids

    item
  end

  private

  def product_name
    if @product.is_variant?
      "#{@product.product.name}, #{@product.name}"
    else
      @product.name
    end
  end

end
