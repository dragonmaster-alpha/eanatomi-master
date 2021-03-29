class Admin::CampaignsController < AdminController
  before_action :set_campaign, only: [:edit, :update, :destroy]
  before_action :set_markets

  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
    @campaign.active_in_market = ActiveInMarket.new.activate!
    @placements = Campaign::PLACEMENTS
  end

  def edit
    @placements = Campaign::PLACEMENTS
  end

  def create
    @campaign = Campaign.new params[:campaign].permit!
    @campaign.save!
    redirect_to [:admin, :campaigns], notice: "#{@campaign} blev oprettet"
  end

  def update
    @campaign.update! params[:campaign].permit!
    redirect_to [:admin, :campaigns], notice: "#{@campaign} blev opdateret"
  end

  def destroy
    @campaign.destroy!
    redirect_to [:admin, :campaigns], notice: "#{@campaign} blev slettet"
  end

  private

    def authorize
      authorize! :update, Campaign
    end

    def set_markets
      @markets = Market.all.map { |market| [market.domain, market.key] }
    end

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end
end
