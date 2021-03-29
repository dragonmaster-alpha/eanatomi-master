class Admin::ManufacturersController < AdminController
  before_action :set_manufacturer, only: [:edit, :update, :destroy]

  def index
    @manufacturers = Manufacturer.all
  end

  def new
    @manufacturer = Manufacturer.new
  end

  def create
    @manufacturer = Manufacturer.new params[:manufacturer].permit!
    @manufacturer.save!
    redirect_to [:admin, :manufacturers], notice: "#{@manufacturer} blev oprettet"
  end

  def update
    @manufacturer.update! params[:manufacturer].permit!
    redirect_to [:admin, :manufacturers], notice: "#{@manufacturer} blev opdateret"
  end

  def destroy
    @manufacturer.destroy!
    redirect_to [:admin, :manufacturers], notice: "#{@manufacturer} blev slettet"
  end

  private

    def authorize
      authorize! :update, Manufacturer
    end

    def set_manufacturer
      @manufacturer = Manufacturer.find(params[:id])
    end

end
