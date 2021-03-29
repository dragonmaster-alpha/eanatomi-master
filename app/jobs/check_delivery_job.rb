class CheckDeliveryJob < ApplicationJob
  queue_as :default

  def perform(order)
    if available_for_delivery?(order)
      order.log!('Undelivered notice sent')
      OrderMailer.pickup(order).deliver_now
    end
  end

  def available_for_delivery?(order)
    shipments_waiting = order.shipments.map do |shipment|
      Shipping.new(shipment.code, distributor: shipment.distributor).available_for_delivery?
    end

    shipments_waiting.any?
  end
end
