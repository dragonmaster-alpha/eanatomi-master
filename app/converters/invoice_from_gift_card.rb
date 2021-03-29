class InvoiceFromGiftCard

  def initialize(gift_card)
    @gift_card = gift_card
  end

  def invoice
    new_invoice = @gift_card.accounting_class::Invoice.new

    new_invoice.customer = customer
    new_invoice.id                 = @gift_card.invoice_id
    new_invoice.date               = @gift_card.created_at
    new_invoice.payment_type       = 'credit_card'
    new_invoice.customer           = customer
    new_invoice.items              = order_items
    new_invoice.currency           = @gift_card.market.currency
    new_invoice.country_code       = @gift_card.market.key
    new_invoice.market             = @gift_card.market.key
    new_invoice.heading            = "##{@gift_card.card_number}"

    new_invoice
  end

  private

    def order_items
      description = I18n.t('activerecord.attributes.order.gift_card', locale: @gift_card.market.locale)
      [@gift_card.accounting_class::InvoiceItem.new(product_id: @gift_card.market.gift_card_id, description: description, sku: @gift_card.market.gift_card_sku, quantity: 1, price: @gift_card.gross_amount)]
    end

    def customer
      new_customer = @gift_card.accounting_class::Customer.new
      new_customer.name         = @gift_card.name
      new_customer.email        = @gift_card.email
      new_customer.country_code = @gift_card.market.key
      new_customer.payment_type = 'credit_card'
      new_customer.market       = @gift_card.market.key
      new_customer.vat          = true
      new_customer
    end
end
