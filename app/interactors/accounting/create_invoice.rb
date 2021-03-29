class Accounting::CreateInvoice
  include Interactor

  def call
    create_invoice if !has_invoice? && context.order.is_invoiced
  end

  private

  def create_invoice
    invoice_id = accounting_class.new(context.order.market.key).create_draft_invoice(invoice)

    ::Invoice.create(reference: invoice_id, order: context.order, status: :draft)

    context.order.log!('Draft invoice created')
  end

  def has_invoice?
    context.order.invoice.persisted?
  end

  def accounting_class
    # Accounting::Tripletex
    # Accounting::Economic
    context.order.accounting_class
  end

  def invoice
    invoice = accounting_class::Invoice.build(context.order)
    invoice.customer = accounting_class::Customer.build(context.order)
    invoice.items = accounting_class::InvoiceItem.build_items(context.order)
    invoice
  end

end
