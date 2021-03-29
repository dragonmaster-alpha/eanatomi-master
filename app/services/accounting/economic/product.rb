class Accounting::Economic::Product < Accounting::Base::Product

  # required: name, productGroup.productGroupNumber, productNumber
  def serialize
    {
      productNumber: @sku,
      name: @name,
      productGroup: {
        productGroupNumber: 1
      }
    }
  end

  def save!
    begin
      Accounting::Economic::Client.new.post('products', self.serialize)
    rescue Accounting::OperationError => e
      if e.message == "Product with number #{@sku} already exists."
        # Accounting::Economic::Client.new.put("products/#{@sku}", self.serialize)
      else
        raise e
      end
    end

    self
  end


end
