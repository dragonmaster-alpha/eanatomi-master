class Admin::InvoicesController < AdminController

  def create
    @order = Order.find(params[:order_id])
    create_invoice = Accounting::CreateInvoice.call(order: @order)
    redirect_to admin_order_path(@order), notice: "Fakturakladde ##{@order.invoice.reference} oprettet"
  end

  private

  def authorize
    authorize! :create, Invoice
  end


end
