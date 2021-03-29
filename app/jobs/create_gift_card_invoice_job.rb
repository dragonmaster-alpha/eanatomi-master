class CreateGiftCardInvoiceJob < ApplicationJob
  queue_as :default

  def perform(gift_card)
    Accounting::CreateGiftCardInvoice.call(gift_card: gift_card)
    GiftCardsMailer.created(gift_card).deliver_later
  end
end
