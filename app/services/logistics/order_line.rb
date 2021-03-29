class Logistics::OrderLine
  attr_accessor :product_number, :quantity, :order_line_text, :product_variant_number, :ean_13

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def serialize
    {
      'order:CountryOfOrigin'      => nil,
      'order:EAN13'                => ean_13,
      'order:OrderlineText'        => order_line_text,
      'order:Price'                => nil.to_f,
      'order:PriceCurrency'        => nil,
      'order:ProductNumber'        => product_number,
      'order:ProductVariantNumber' => product_variant_number,
      'order:Quantity'             => quantity.to_i,
      'order:TarifCode'            => nil,
      'order:TarifDescription'     => nil,
      'order:Weight'               => nil.to_i
    }
  end

end
