class Shiphero::Product

  def initialize(product)
    @product = product
  end

  def create!
    Shiphero::Client.new.post('v1.2/general-api/product-creation/', self.serialize)
  end

  def update!
    Shiphero::Client.new.post('v1.2/general-api/update-inventory/', self.serialize)
  end

  def serialize
    {
      title: @product.name_nb,
      sku: @product.sku,
      available_inventory: 0,
      barcode: @product.barcode,
      value: @product.cost_price,
      price: @product.price,
      brand: @product.manufacturer&.name,
      images: images,
      warehouse: "Alnabru"
    }
  end

  private

  def images
    @product.photos.map do |photo|
      {
        src: photo.url,
        position: photo.position
      }
    end
  end

end
