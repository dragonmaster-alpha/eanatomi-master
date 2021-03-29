class SubscribeOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    Subscription.new(order.email, order.market.key, name: order.name).subscribe
  end
end
