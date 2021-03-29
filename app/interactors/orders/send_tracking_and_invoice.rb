class Orders::SendTrackingAndInvoice
  include Interactor

  def call
    send_tracking
    send_invoice if invoice?
    create_and_send_customs_invoice if context.order.market.customs_invoice
  end

  private

  def create_and_send_customs_invoice
    CreateCustomsInvoiceJob.perform_later(context.order)
  end

  def invoice?
    !(%w( klarna ean_invoice vat_invoice ).include?(context.order.payment_method)) &&
      context.order.is_invoiced
  end

  def send_tracking
    context.order.log!('Tracking sent')
    OrderMailer.shipped(context.order).deliver_later
  end

  def send_invoice
    context.order.log!('Invoice sent')
    OrderMailer.invoice(context.order).deliver_later(wait: 10.minutes)
  end

end
