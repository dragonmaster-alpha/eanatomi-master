class CreateLogisticsOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    Logistics::CreateOrder.call(order: order)
  end
end
