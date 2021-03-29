class Logistics::UpdateTracking
  include Interactor

  def call
    context.codes.each do |code|
      if order = Order.find_by(order_number: code[:order_number])
        Shipment.find_or_create_by(order: order, code: code[:code])
      end
    end
  end
end
