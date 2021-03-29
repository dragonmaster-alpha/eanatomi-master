class Logistics::CancelOrder
  include Interactor

  def call
    case context.order.warehouse
    when 'e-logistik'
      call_e_logistik
    when 'shiphero'
      call_shiphero
    end

    context.order.cancelled!

    context.order.log!('Order cancelled')
  end

  private

  def call_e_logistik
    Logistics.new.cancel_order(context.order.order_number)
  end

  def call_shiphero
  end

end
