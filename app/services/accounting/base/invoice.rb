class Accounting::Base::Invoice
  attr_accessor :id,
    :date,
    :delivery_name,
    :delivery_attention,
    :delivery_address,
    :delivery_address2,
    :delivery_city,
    :delivery_zip,
    :delivery_country,
    :payment_type,
    :items,
    :currency,
    :country_code,
    :attention,
    :market,
    :ean_number,
    :reference,
    :heading,
    :note,
    :order_number,
    :customer,
    :total_amount,
    :is_paid

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def items
    @items ||= []
  end

  def save!
    raise NotImplementedError
  end

  def self.build(order)
    self.new(
      :id                 => order.invoice&.reference,
      :date               => order.placed_at,
      :delivery_name      => order.shipping_address.name,
      :delivery_attention => order.shipping_address.att,
      :delivery_address   => order.shipping_address.street,
      :delivery_city      => order.shipping_address.city,
      :delivery_zip       => order.shipping_address.zip_code,
      :delivery_country   => order.shipping_address.country,
      :country_code       => order.invoice_address.country_code,
      :attention          => order.invoice_address.att,
      :payment_type       => order.payment_method,
      :currency           => order.market.currency,
      :market             => order.market.key,
      :ean_number         => order.ean_number,
      :reference          => order.reference_number,
      :order_number       => order.order_number,
      :heading            => "##{order.order_number}",
      :note               => "Tracking: #{order.shipments.pluck(:code).join(', ')}",
      :total_amount       => order.net_amount,
      :is_paid            => order.payed_with_card?
    )
  end

end
