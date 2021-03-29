class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id]).decorate
  end

  def payment
    @order = Order.find(params[:order_id])
    redirect_to @order.payment_link
  end

end
