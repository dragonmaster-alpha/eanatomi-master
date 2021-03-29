class Accounting::Economic < Accounting::Base

  def create_draft_invoice(invoice)
    invoice.customer.save!
    invoice.save!
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
    product.market = @market
    product.save!
    product.id
  end

  private

  class Response < Struct.new(:success, :body)
  end

end
