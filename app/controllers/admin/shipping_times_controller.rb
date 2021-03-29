class Admin::ShippingTimesController < AdminController
  before_action :set_shipping_time, only: [:edit, :update, :destroy]

  def index
    @shipping_times = ShippingTime.all
  end

  def new
    @shipping_time = ShippingTime.new
  end

  def create
    @shipping_time = ShippingTime.new params[:shipping_time].permit!
    @shipping_time.save!
    redirect_to [:admin, :shipping_times], notice: "#{@shipping_time} blev oprettet"
  end

  def update
    @shipping_time.update! params[:shipping_time].permit!
    redirect_to [:admin, :shipping_times], notice: "#{@shipping_time} blev opdateret"
  end

  def destroy
    @shipping_time.destroy!
    redirect_to [:admin, :shipping_times], notice: "#{@shipping_time} blev slettet"
  end

  private

    def authorize
      authorize! :update, ShippingTime
    end

    def set_shipping_time
      @shipping_time = ShippingTime.find(params[:id])
    end

end
