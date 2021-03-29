class Admin::ProductSalesController < AdminController

  def show
    @products = to_array(Product.all).insert(0, ['-', nil])

    I18n.with_locale(ENV['DEFAULT_LOCALE']) do
      gon.products = Product.all.map do |product|
          { id: product.id, name: product.name, sku: product.sku }
      end
  end

    @product_sale = ProductSale.new(params[:product_sale]&.permit!)
  end

  private

  def authorize
    authorize! :read, ProductSale
  end

  def to_array(collection)
    collection.map do |item|
      [item.option_name, item.id]
    end.sort
  end

end
