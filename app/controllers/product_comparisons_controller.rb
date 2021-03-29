class ProductComparisonsController < ApplicationController

  def show
    products = params[:products].split(',').map do |id|
      Product.slug(id)
    end

    @comparison = ProductComparison.new(products)
  end

end
