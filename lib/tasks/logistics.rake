namespace :logistics do

  desc "Sends all products to logistics"
  task create_products: :environment do
    Logistics::Product # autoload logistics/product

    products = Product.no_components.map do |item|
      Logistics::Product.new(ean: item.ean_number, product_id: item.sku, product_name: item.name_da)
    end

    Product.where.not(barcode: [nil, '']).each do |product|
      Shiphero::Product.new(product).create!
    end


    Logistics.new.send_products(products)
  end


  desc 'Gets minutely order status'
  task minutely: :environment do
    Logistics::UpdateStatus.call events: Logistics.new.get_order_status(1.hour.ago)
  end

  desc 'Gets hourly order status'
  task hourly: :environment do
    Logistics::UpdateStatus.call events: Logistics.new.get_order_status(1.day.ago)
  end

  desc 'Gets daily order status'
  task daily: :environment do
    Logistics::UpdateStatus.call events: Logistics.new.get_order_status(6.month.ago)
  end

  desc 'Update stock info'
  task update_stock: :environment do
    Logistics.new.get_stock(Product.pluck(:sku)).each do |stock_info|
      if product = Product.find_by("lower(sku) = ?", stock_info[:ean].downcase.strip)
        product.update! stock: stock_info[:in_stock]
      end
    end
  end

end
