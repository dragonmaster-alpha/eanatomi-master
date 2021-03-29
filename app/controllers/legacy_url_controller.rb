class LegacyUrlController < ApplicationController

  def product
    product_reference = /\A\d+/.match(params[:product]).to_s

    if product = Product.find_by(reference: product_reference)
      redirect_to product, status: 301
    else
      category
    end
  end

  def category
    category_reference = /\A\d+/.match(params[:category]).to_s

    if category = Category.find_by(reference: category_reference)
      redirect_to category, status: 301
    else
      not_found
    end
  end

end
