class Accounting::Base::Customer
  attr_accessor :id,
  :name,
  :email,
  :phone,
  :address,
  :address2,
  :zip,
  :city,
  :country,
  :country_code,
  :vat_number,
  :payment_type,
  :market,
  :vat

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def save!
    raise NotImplementedError
  end

  def self.build(order)
    self.new(
      :name         => order.name,
      :email        => order.email,
      :phone        => "#{order.market.phone_prefix}#{order.phone}",
      :address      => order.address,
      :address2     => order.address2,
      :zip          => order.zip_code,
      :city         => order.city,
      :country      => order.country,
      :country_code => order.market.country_code,
      :vat_number   => order.vat_number,
      :payment_type => order.payment_method,
      :market       => order.market.key,
      :vat          => order.vat?
    )
  end

end
