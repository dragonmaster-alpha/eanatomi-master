class Orders::UpdateShipping
  include Interactor

  def call
    context.order.status = :shipped_complete
    context.order.shipped_at ||= DateTime.now
    context.order.save!

    if context.order.warehouse == 'e-logistik'
      shipment_ids.each do |id|
        Shipment.find_or_create_by(order: context.order, code: id)
      end
    end
  end

  private

    def shipment_ids
      Logistics.new.get_tracking_code(context.order.order_number)
    end
end
