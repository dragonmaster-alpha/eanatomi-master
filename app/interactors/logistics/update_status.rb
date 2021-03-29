class Logistics::UpdateStatus
  include Interactor

  def call
    context.events.each do |event|
      process_event(event)
    end
  end

  private

    def process_event(event)
      if order = Order.find_by(order_number: event[:order_number])
        shipping_event = ShippingEvent.find_or_initialize_by(order_id: order.id, status_code: event[:order_status_id])
        if shipping_event.new_record?
          shipping_event.occurred_at = event[:date]
          shipping_event.status = event[:status]
          shipping_event.save!
          order.update_status!

          OrderShippedJob.perform_later(order) if shipping_event.shipped_complete?
        end
      end
    end
end
