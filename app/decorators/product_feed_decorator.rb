class ProductFeedDecorator < Draper::Decorator
  delegate_all

  def id
    object.sku
  end

  def title
    object.name
  end

  def description
    h.strip_tags(object.description)
  end

  def image_link
    photo.url(w: 800, h: 800)
  end

  def photo
    sorted_photos.first
  end

  def photo?
    sorted_photos.any?
  end

  def link
    h.product_url(object)
  end

  def condition
    'new'
  end

  def availability
    if stock.to_i.nonzero?
      'in stock'
    else
      'out of stock'
    end
  end

  def gtin
    object.sku
  end

  def manufacturer
    object.manufacturer || Manufacturer.new
  end

  def brand
    manufacturer.name
  end

  def price
    to_currency(object.price)
  end

  def sales_price
    to_currency(object.sales_price)
  end

  def to_currency(amount)
    amount = Currency.new(amount, market.rate, market.vat).net_amount
    h.number_to_currency(amount, format: "%n %u")
  end

  def market
    context[:market]
  end

  def google_product_category
    'Business & Industrial > Medical > Medical Equipment'
  end

  def product_type
    if parents = context[:category_tree][category_id]
      parents.flatten.reverse.map(&:name).join(' > ')
    end
  end

  def additional_image_links
    links = sorted_photos.to_a.map { |p| p.url(w: 800, h: 800) }
    links.shift

    links.to_a.take(10)
  end

  def gift_card?
    sku == 'GKEA'
  end

end
