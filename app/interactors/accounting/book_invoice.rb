class Accounting::BookInvoice
  include Interactor

  def call
    if is_draft? && !payed_with_invoice? && context.order.is_invoiced
      book_invoice
      attach_pdf
    end
  end

  private

  def is_draft?
    context.order.persisted? && context.order.invoice.draft?
  end

  def payed_with_invoice?
    %w( ean_invoice vat_invoice ).include? context.order.payment_method
  end

  def book_invoice
    invoice_id = accounting_class.new(context.order.market.key).book_invoice(invoice)

    context.order.invoice.update! reference: invoice_id

    context.order.log!('Invoice booked')
  end

  def invoice
    accounting_class::Invoice.build(context.order)
  end

  def attach_pdf
    file = accounting_class.new(context.order.market.key).get_invoice_pdf(invoice)
    context.order.invoice.update! status: :booked, file: file
  end

  def accounting_class
    context.order.accounting_class
  end
end
