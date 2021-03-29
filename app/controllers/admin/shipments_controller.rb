class Admin::ShipmentsController < AdminController

  def create
    @order = Order.find(params[:order_id])
    Logistics::CreateOrder.call(order: @order)
    redirect_to [:admin, @order], notice: 'Ordren blev sendt til lageret'
  end

  private

    def authorize
      authorize! :update, Logistics
    end

end
