class Logistics::CreateOrder
  include Interactor

  def call
    begin
      call_warehouse
    rescue Exception => e
      ::Failure.create(order: context.order, exception: e.class, message: e.message, status: :unseen, context: self.class.name)
      raise e
    end

    context.order.update warehouse_id: context.warehouse_id
    context.order.log!('Sent to logistics')

    ::Failure.where(order: context.order, context: self.class.name).update_all(status: :fixed)
  end

  private

  def call_warehouse
    case context.order.warehouse
    when 'e-logistik'
      call_e_logistik
    when 'shiphero'
      call_shiphero
      create_shipping_event
    end
  end

  def call_e_logistik
    Logistics::SendProducts.call(order: context.order)

    client = Logistics.new
    customer_order = CustomerOrderFromOrder.new(context.order).customer_order
    client.send_order(customer_order)
  end

  def call_shiphero
    shiphero_order = Shiphero::Order.new(context.order)
    shiphero_order.save!
    context.warehouse_id = shiphero_order.id
  end

  def create_shipping_event
    ShippingEvent.create(order: context.order, status: :received, occurred_at: DateTime.now)
    context.order.update_status!
  end

end
