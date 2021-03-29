class Admin::DuplicatesController < AdminController

  def create
    @order = Order.find(params[:order_id])
    @duplicate = Orders::Duplicate.call(order: @order).duplicate
    redirect_to [:admin, @duplicate], notice: 'Ordren blev kopieret'
  end

  private

    def authorize
      authorize! :update, Order
    end

end
