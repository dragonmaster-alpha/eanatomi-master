class Logistics::SendProducts
  include Interactor

  def call
    case Rails.application.warehouse
    when 'e-logistik'
      call_e_logistik
    when 'shiphero'
      call_shiphero
    end
  end

  private

  def call_e_logistik
    products = ExpandedOrderItems.new(context.order.order_items).uniq_items.map do |item|
      Logistics::Product.new(ean: item.ean_number, product_id: item.sku_code, product_name: item.name)
    end

    Logistics.new.send_products(products)
  end

  def call_shiphero
    products = context.order.order_items.map do |item|
      Shiphero::Product.new(item.product).create! if item.product.barcode.present?
    end
  end

end
