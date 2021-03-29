namespace :accounting do
  desc "Creates all products in accouting"
  task create_products: :environment do
    Product.find_each do |product|
      puts("Creating product #{product.sku}")
      Accounting::CreateProduct.call(product: product)
    end
  end

end
