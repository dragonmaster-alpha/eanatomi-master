class Orders::InvoicesController < ApplicationController

  def show
    order = Order.find(params[:order_id])
    redirect_to order.invoice.file_url
  end

end
