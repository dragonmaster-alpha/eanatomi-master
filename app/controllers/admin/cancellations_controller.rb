class Admin::CancellationsController < AdminController

  def create
    authorize! :update, Order
    @order = Order.find(params[:order_id])
    Logistics::CancelOrder.call(order: @order)
    redirect_to [:admin, @order], notice: 'Ordren blev annulleret'
  end

  private

    def authorize
      authorize! :update, Order
    end

end
