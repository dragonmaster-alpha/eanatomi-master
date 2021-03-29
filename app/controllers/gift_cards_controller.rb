class GiftCardsController < ApplicationController

  def new
    @gift_card = GiftCard.new
  end

  def show
    @gift_card = GiftCard.find params[:id]
  end

  def download
    @gift_card = GiftCard.find params[:gift_card_id]
    send_data(@gift_card.file.read, filename: 'gavekort.pdf', type: 'application/pdf')
  end

  def create
    @gift_card = GiftCard.new(params[:gift_card].permit(:name, :email, :net_amount, :recipient, :message))
    @gift_card.status = :unpaid
    @gift_card.market_id = context.market.key
    @gift_card.save!

    accepturl = gift_card_payments_url(@gift_card)

    render json: {
      paymentwindow: Billing.new(@gift_card).payment_params(accepturl, capture: true)
    }

  end

end
