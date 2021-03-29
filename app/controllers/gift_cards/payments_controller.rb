class GiftCards::PaymentsController < ApplicationController

  def index
    @gift_card = GiftCard.find(params[:gift_card_id])

    if @gift_card.unpaid?
      GiftCards::Paid.call(gift_card: @gift_card, payment_id: params[:txnid])
    end

    redirect_to @gift_card
  end

end
