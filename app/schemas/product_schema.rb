class ProductSchema < ApplicationSchema

  def initialize(product, market = Market.fetch(:dk), url: nil)
    @product = product
    @market = market
    @url = url
  end

  def structure
    {
      '@context' => 'http://schema.org',
      '@type' => 'Product',
      'name' => name,
      'description' => description,
      'image' => image,
      'url' => url,
      'brand' => brand,
      'sku' => sku,
      'offers' => @product.variants.map do |variant|
        {
          '@type' => 'Offer',
          'availability' => availability(variant),
          'price' => price(variant),
          'priceCurrency' => currency,
          'name' => variant.name
        }
      end
    }
  end

  def availability(product)
    product.in_stock? ? 'http://schema.org/InStock' : 'http://schema.org/OutOfStock'
  end

  def price(product)
    Currency.new(product.sales_price, @market.rate, @market.vat).net_amount
  end

  def name
    @product.name
  end

  def sku
    @product.sku
  end

  def brand
    @product.manufacturer&.name
  end

  def url
    @url
  end

  def currency
    @market.currency.upcase
  end

  def image
    @product.photo.imgix_photo_url
  end

  def description
    sanitzier.sanitize(@product.description)
  end

  def sanitzier
    Rails::Html::FullSanitizer.new
  end


end
