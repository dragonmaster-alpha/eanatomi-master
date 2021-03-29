class Checkout::Orders::GiftCardsController < ApplicationController

  def create
    @order = Order.find params[:order_id]
    @gift_card = GiftCard.find_by(code: params[:gift_card][:code])

    if @gift_card
      @order.update! gift_card: @gift_card
      redirect_to [:new, :checkout, :order], notice: t('.success')
    else
      flash[:alert] = t('.not_found')
      redirect_to [:new, :checkout, :order]
    end

  end

end
