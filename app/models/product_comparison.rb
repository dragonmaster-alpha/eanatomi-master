class ProductComparison
  attr_accessor :products

  def initialize(products)
    @products = products.take(4)
  end

  def photos
    @products.map(&:photo)
  end

  def names
    @products.map(&:name)
  end

  def sizes
    @products.map(&:size)
  end

  def prices
    @products.map(&:price)
  end

  def labels
    @products.map(&:label)
  end

end
