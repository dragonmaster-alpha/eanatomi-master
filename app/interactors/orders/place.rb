class Orders::Place
  include Interactor

  def call
    context.order.update!(
      status: :placed,
      placed_at: DateTime.now,
      accounting_class: context.order.market.accounting_class,
      warehouse: Rails.application.warehouse
    )

    context.order.lock_fees!
    context.order.lock_sales_price!

    if context.order.gift_card?
      GiftCardTransaction.create! gift_card: context.order.gift_card, order: context.order, net_amount: context.order.gift_card_net_amount
    end

    if context.order.is_subscribing
      SubscribeOrderJob.perform_later(context.order)
    end

    context.order.log!('Order placed')

    CreateLogisticsOrderJob.perform_later(context.order) unless context.order.needs_review?

    context.order.log!('Confirmation sent')
    OrderMailer.confirmation(context.order).deliver_later

    OrderWaitingJob.set(wait: 1.hour).perform_later(context.order)
  end
end
