class Accounting::Tripletex < Accounting::Base

  def create_draft_invoice(invoice)
    invoice.customer.save!
    invoice.save!
    invoice.items.each { |item| item.invoice = invoice }
    invoice.items.each &:save!

    invoice.id
  end

  def book_invoice(invoice)
    invoice.book!
    invoice.id
  end

  def get_invoice_pdf(invoice)
    invoice.invoice_pdf
  end

  def create_product(product)
    product.save!
    product.id
  end

end
