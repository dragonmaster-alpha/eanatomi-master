class OrderItemDecorator < Draper::Decorator
  delegate_all
  decorates_association :product

  def size
    product.size
  end

  def stock
    product.stock.to_i
  end

  def description
    if size.present?
      "#{name}, #{size}"
    else
      name
    end
  end

  def shipping_time_description
    product.shipping_time_description
  end

end
