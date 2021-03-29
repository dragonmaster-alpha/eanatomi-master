class LegacyUrl < ApplicationRecord

  def object
    if kind == 'product'
      Product.find_by(sku: reference)
    elsif kind == 'category'
      Category.find_by(reference: reference)
    end
  end

end
