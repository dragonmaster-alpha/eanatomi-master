class Accounting::Economic::InvoiceItem < Accounting::Base::InvoiceItem

  def serialize
    {
      product: {
        productNumber: sku.to_s
      },
      description: description.to_s,
      quantity: quantity.to_i,
      unitNetPrice: price.to_f
    }
  end

end
