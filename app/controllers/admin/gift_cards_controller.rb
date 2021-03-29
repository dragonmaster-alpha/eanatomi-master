class Admin::GiftCardsController < AdminController

  def index
    @gift_cards = GiftCard.all
  end

  def show
    @gift_card = GiftCard.find params[:id]
  end

  private


  def authorize
    authorize! :update, GiftCard
  end


end
