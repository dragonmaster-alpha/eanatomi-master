class VendorPrice < ApplicationRecord
  belongs_to :product
  belongs_to :user

  def sales_price
    product.sales_price - savings if product
  end

  def savings
    product.sales_price / 100 * discount
  end

end
