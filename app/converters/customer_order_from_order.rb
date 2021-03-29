class CustomerOrderFromOrder

  def initialize(order)
    @order = order
  end

  def customer_order
    Logistics::CustomerOrder.new(order_number: @order.order_number, order_lines: order_lines, order_invoice_information: order_information)
  end

  private

    def order_lines
      ExpandedOrderItems.new(@order.order_items).uniq_items.map do |item|
        Logistics::OrderLine.new(product_number: item.ean_number, quantity: item.quantity, order_line_text: item.name, ean_13: item.sku_code)
      end
    end

    def order_information
      information = Logistics::OrderInvoiceInformation.new

      if @order.servicepoint?
        information.delivery_place_id       = @order.servicepoint_address.code
        information.delivery_place_name     = @order.servicepoint_address.name
        information.delivery_place_address  = @order.servicepoint_address.street
        information.delivery_place_zip_code = @order.servicepoint_address.zip_code
        information.delivery_place_city     = @order.servicepoint_address.city
        information.delivery_place_country  = @order.servicepoint_address.country_code
      end

      information.delivery_name           = @order.shipping_address.name
      information.delivery_address        = @order.shipping_address.street
      information.delivery_zip            = @order.shipping_address.zip_code
      information.delivery_city           = @order.shipping_address.city
      information.delivery_country        = @order.shipping_address.country_code
      information.delivery_attention      = @order.shipping_address.att

      information.customer_number         = @order.phone
      information.shipping_form           = shipping_form
      information.email                   = @order.email
      information.phone                   = phone_number
      information.delivery_instructions   = @order.flex_instructions if @order.flex?
      information.courier                 = @order.courier

      information
    end

    def phone_number
      @order.phone
    end

    def shipping_form
      if @order.servicepoint?
        'servicepoint'
      elsif @order.delivery_method == 'droppoint'
        'nearest'
      elsif @order.flex?
        'flex'
      elsif @order.delivery_method == 'business' || @order.client_type == 'business' || @order.client_type == 'public'
        'business'
      else
        'standard'
      end
    end
end
