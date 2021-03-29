class Orders::CheckDelivery
  include Interactor

  def call
    CheckDeliveryJob.set(wait: 7.days).perform_later(context.order)
  end

end