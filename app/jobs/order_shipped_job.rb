class OrderShippedJob < ApplicationJob
  queue_as :default

  def perform(order)
    begin
      Orders::Shipped.call(order: order)
    rescue Exception => e
      Failure.create(order: order, exception: e.class, message: e.message, status: :unseen, context: self.class.name)
      raise e
    end

    ::Failure.where(order: order, context: self.class.name).update_all(status: :fixed)
  end
end
