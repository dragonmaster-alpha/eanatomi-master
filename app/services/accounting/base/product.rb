class Accounting::Base::Product
  attr_accessor :id, :name, :market, :sku

  def initialize(args={})
    args.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def save!
    raise NotImplementedError
  end

  def self.build(product)
    self.new(
      id: nil,
      name: product.name,
      sku: product.sku
    )
  end

end
