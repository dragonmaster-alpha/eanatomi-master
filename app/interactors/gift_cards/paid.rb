class GiftCards::Paid
  include Interactor

  def call
    context.gift_card.update! payment_id: context.payment_id, status: :paid
    GiftCards::CreatePDF.call(gift_card: context.gift_card)
    CreateGiftCardInvoiceJob.perform_later(context.gift_card)
  end
end
