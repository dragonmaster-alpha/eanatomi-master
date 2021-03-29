class Admin::Orders::PaymentsController < AdminController

  def create
    @order = Order.find(params[:order_id])
    accepturl = checkout_order_payments_url(@order)
    payment_link = Billing.new(@order).payment_link(accepturl, cancelurl: Market.first.url)

    @order.update! payment_link: payment_link, payment_method: 'credit_card', needs_confirmation: false, status: :pending_payment
    @order.payment.destroy

    OrderMailer.payment(@order).deliver_later

    @order.log!('Sent paymentlink')

    redirect_to [:admin, @order], notice: 'Betalingslink blev afsendt'
  end


  private

    def authorize
      authorize! :update, Order
    end

end
