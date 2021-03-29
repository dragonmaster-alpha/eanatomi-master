class Shiphero::Order
  attr_accessor :id, :error

  def initialize(order)
    @order = order
  end

  def save!
    response = if @order.warehouse_id
      Shiphero::Client.new.post('v1.2/general-api/order-update', serialize)
    else
      Shiphero::Client.new.post('v1.2/general-api/order-creation', serialize)
    end

    result = JSON.parse(response.body)

    if result['code'] == 200
      @id = result['order_id']
      true
    else
      raise Shiphero::RequestError, result['message']
    end
  end

  def serialize
    {
      email: @order.email,
      line_items: line_items,
      total_tax: @order.vat_amount,
      subtotal_price: @order.gross_amount,
      total_price: @order.net_amount,
      total_discounts: 0,
      created_at: @order.placed_at,
      required_ship_date: DateTime.now,
      fulfillment_status: 'pending',
      order_id: @order.order_number,
      profile: 'default',
      shipping_lines: {
        title: shipping_method,
        price: @order.delivery_fee,
        method: @order.delivery_method,
        carrier: @order.courier
      },
      shipping_address: {
        first_name: first_name,
        last_name: last_name,
        company: company,
        phone: phone,
        address1: @order.shipping_address.street,
        address2: '',
        city: @order.shipping_address.city,
        province: '',
        province_code: '',
        zip: @order.shipping_address.zip_code,
        country: @order.shipping_address.country,
        country_code: @order.shipping_address.country_code
      },
      note_attributes: {
        name: '',
        value: ''
      }
    }
  end

  def company
    @order.shipping_address.name if @order.shipping_address.att.present?
  end

  def phone
    @order.phone.gsub(/ -/, '')
  end

  def first_name
    if names.length == 1
      names.first
    else
      names[0, names.length.pred].join(' ')
    end
  end

  def last_name
    names.last
  end

  def names
    if @order.shipping_address.att.present?
      @order.shipping_address.att.split(' ')
    else
      @order.shipping_address.name.split(' ')
    end
  end

  def line_items
    @order.order_items.map do |order_item|
      Shiphero::LineItem.new(order_item).serialize
    end
  end

  def shipping_method
    methods = if @order.client_type == 'private'
      {
        'door' => 'PostNord MyPack Home',
        'pickup' => 'Pick-up-point Oslo',
        'droppoint' => 'PostNord MyPack'
      }
    else
      {
        'door' => 'PostNord Bedrift',
        'pickup' => 'Pick-up-point Oslo',
        'droppoint' => 'PostNord MyPack'
      }
    end

    methods[@order.delivery_method]
  end

end
