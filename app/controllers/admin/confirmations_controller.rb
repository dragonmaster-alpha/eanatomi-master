class Admin::ConfirmationsController < AdminController

  def create
    @order = Order.find(params[:order_id])
    OrderMailer.confirmation(@order).deliver_later
    @order.log!('Sent confirmation')
    CreateLogisticsOrderJob.perform_later(@order)
    redirect_to [:admin, @order], notice: 'Bekræftelse blev afsendt og ordren blev sendt til lageret'
  end

  private

    def authorize
      authorize! :update, Order
    end

end
