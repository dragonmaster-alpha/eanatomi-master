class Orders::CustomsInvoicesController < ApplicationController

  def show
    @order = Order.find(params[:order_id]).decorate
    render layout: false
  end

end
