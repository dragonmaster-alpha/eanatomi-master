class Accounting::Base

  def initialize(market = nil)
    @market = market
  end

  def create_customer(customer)
    raise NotImplementedError
  end

  def create_draft_invoice(invoice)
    raise NotImplementedError
  end

  def book_invoice(invoice)
    raise NotImplementedError
  end

  def get_invoice_pdf(invoice)
    raise NotImplementedError
  end

  def create_product(product)
    raise NotImplementedError
  end

end
