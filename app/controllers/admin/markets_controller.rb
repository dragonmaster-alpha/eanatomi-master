class Admin::MarketsController < AdminController
  before_action :set_market, only: [:edit, :update, :destroy]

  def index
    @markets = Market.all
  end

  def new
    @market = Market.new
  end

  def edit
  end

  def update
    @market.attributes = market_params
    @market.update! market_params

    redirect_to [:admin, :markets], notice: "#{@market} blev opdateret"
  end

  def destroy
    @market.destroy
    redirect_to [:admin, :markets], notice: "#{@market} blev slettet"
  end

  private

    def authorize
      authorize! :update, Market
    end

    def market_params
      params[:market].permit!
    end

    def set_market
      @market = Market.find(params[:id])
    end
end
