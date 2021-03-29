class Admin::NoticesController < AdminController
  before_action :set_notice, only: [:edit, :update, :destroy]
  before_action :set_markets

  def index
    @notices = Notice.all
  end

  def new
    @notice = Notice.new
    @notice.active_in_market = ActiveInMarket.new.activate!
  end

  def edit
  end

  def create
    @notice = Notice.new params[:notice].permit!
    @notice.save!
    redirect_to [:admin, :notices], notice: "Beskeden blev oprettet"
  end

  def update
    @notice.update! params[:notice].permit!
    redirect_to [:admin, :notices], notice: "Beskeden blev opdateret"
  end

  def destroy
    @notice.destroy!
    redirect_to [:admin, :notices], notice: "Beskeden blev slettet"
  end

  private

    def authorize
      authorize! :update, Notice
    end

    def set_markets
      @markets = Market.all.map { |market| [market.domain, market.key] }
    end

    def set_notice
      @notice = Notice.find(params[:id])
    end
end
