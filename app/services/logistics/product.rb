class Logistics::Product
  attr_accessor :ean, :product_id, :product_name, :product_variant_id, :product_variant_name, :supplier_product_number

  def initialize(args={})
    args.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def serialize
    {
      'product:Product' => {
        'product:EAN'                   => ean,
        'product:ProductID'             => product_id,
        'product:ProductName'           => product_name,
        'product:ProductVariantID'      => product_variant_id,
        'product:ProductVariantName'    => product_variant_name,
        'product:SupplierProductNumber' => supplier_product_number
      }
    }
  end

end
