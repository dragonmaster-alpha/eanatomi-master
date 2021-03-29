class Admin::DeliveryMethodsController < AdminController
  before_action :set_delivery_method, only: [:edit, :update, :destroy]

  def index
    @delivery_methods = DeliveryMethod.sorted
  end

  def new
    @delivery_method = DeliveryMethod.new
  end

  def edit
  end

  def update
    @delivery_method.attributes = delivery_method_params
    @delivery_method.update! delivery_method_params

    redirect_to [:admin, :delivery_methods], notice: "#{@delivery_method} blev opdateret"
  end

  def destroy
    @delivery_method.destroy
    redirect_to [:admin, :delivery_methods], notice: "#{@delivery_method} blev slettet"
  end

  private

    def authorize
      authorize! :update, DeliveryMethod
    end

    def delivery_method_params
      params[:delivery_method].permit!
    end

    def set_delivery_method
      @delivery_method = DeliveryMethod.find(params[:id])
    end
end
