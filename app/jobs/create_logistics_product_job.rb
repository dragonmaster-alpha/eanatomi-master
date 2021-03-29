class CreateLogisticsProductJob < ApplicationJob
  queue_as :default

  def perform(product)
    case Rails.application.warehouse
    when 'e-logistik'
      product = Logistics::Product.new(ean: product.ean_number, product_id: product.sku, product_name: product.name_da)
      Logistics.new.send_products([product])
    when 'shiphero'
      Shiphero::Product.new(product).create! if product.barcode.present?
    end
  end
end
