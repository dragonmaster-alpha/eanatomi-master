class Admin::ReviewsController < AdminController
    def create
    @order = Order.find(params[:order_id])
    @order.update! is_reviewed: true, needs_review: false
    @order.log!('Order reviewed')

    CreateLogisticsOrderJob.perform_later(@order)

    redirect_to [:admin, @order], notice: 'Ordren blev bekræftet'
  end

  private

    def authorize
      authorize! :update, Order
    end
end
