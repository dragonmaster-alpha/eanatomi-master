class Checkout::Orders::PaymentsController < ApplicationController

  def show
    @order = Order.find(params[:order_id])

    if @order.payment.new_record?
      amount = BigDecimal(params[:amount]) / 100
      currency = Billing.currency(params[:currency])
      Payment.create!(order: @order, reference: params[:txnid], status: :authorized, authorized_amount: amount, currency: currency)

      ::Orders::SetReviewAndVatStatus.call(order: @order)
      ::Orders::SetInStockCache.call(order: @order)
      ::Orders::Place.call(order: @order)
    end

    respond_ok
  end

  private

  def respond_ok
    if epay_callback?
      head :ok
    else
      redirect_to [:checkout, @order]
    end
  end

  def epay_callback?
    session.empty?
  end

end
