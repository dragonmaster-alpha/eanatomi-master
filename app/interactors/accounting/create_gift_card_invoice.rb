class Accounting::CreateGiftCardInvoice
  include Interactor

  def call
    create_draft_invoice
    book_invoice
    attach_pdf
  end

  private

  def create_draft_invoice
    invoice_id = accounting_class.new(context.gift_card.market.key).create_draft_invoice(invoice)
    ::Invoice.create(reference: invoice_id, gift_card: context.gift_card, status: :draft)
  end

  def book_invoice
    invoice_id = accounting_class.new(context.gift_card.market.key).book_invoice(invoice)
    context.gift_card.invoice.update! reference: invoice_id
  end

  def attach_pdf
    file = accounting_class.new(context.gift_card.market.key).get_invoice_pdf(invoice)
    context.gift_card.invoice.update! status: :booked, file: file
  end

  def accounting_class
    # Accounting::Tripletex
    # Accounting::Economic
    context.gift_card.market.accounting_class
  end

  def invoice
    @_invoice ||= InvoiceFromGiftCard.new(context.gift_card).invoice
  end

end
