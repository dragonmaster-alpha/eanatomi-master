class Accounting::Tripletex::Product < Accounting::Base::Product

  def save!
    if @id
      Accounting::Tripletex::Client.new.put("product/#{@id}", self.serialize)
    elsif search_product['count'] == 1
      @id = search_product['values'].first['id']
    else
      result = Accounting::Tripletex::Client.new.post('product', self.serialize)
      @id = result['value']['id']
    end

    self
  end

  def serialize
    {
      id: @id,
      name: @name,
      number: @sku
    }
  end

  def search_product
    @_search_product ||= Accounting::Tripletex::Client.new.get("product?productNumber=#{CGI.escape(@sku)}")
  end

  def self.build(product)
    super.tap do |item|
      item.id = product.tripletex_id
    end
  end

  private

end
