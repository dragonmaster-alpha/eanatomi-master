class CreateCustomsInvoiceJob < ApplicationJob
  queue_as :default

  def perform(order)
    begin
      @order = order

      invoice.save!
      invoice.book!

      OrderMailer.customs_invoice(@order, invoice.invoice_pdf).deliver_now
      @order.log!('Customs invoice sent')
    rescue Exception => e
      Failure.create(order: @order, exception: e.class, message: e.message, status: :unseen, context: self.class.name)
      raise e
    end

    ::Failure.where(order: @order, context: self.class.name).update_all(status: :fixed)
  end

  private

  def invoice
    @_draft_invoice ||= Accounting::Economic::Invoice.new(
      currency: customer.currency_code,
      layout_id: customer.layout_id,
      payment_terms_id: customer.payment_terms_id,
      reference: "Ordrenr. #{@order.order_number}",
      customer: customer,
      items: items,
      total_amount: items.map { |item| item.quantity * item.price }.sum,
      delivery_name: @order.shipping_address.name,
      delivery_attention: @order.shipping_address.att,
      delivery_address: @order.shipping_address.street,
      delivery_city: @order.shipping_address.city,
      delivery_zip: @order.shipping_address.zip_code,
      delivery_country: @order.shipping_address.country,
    )
  end

  def customer
    @_customer ||= Accounting::Economic::Customer.find(918716)
  end

  def items
    @_items ||= ExpandedOrderItems.new(@order.order_items).uniq_items.map do |item|
      Accounting::Economic::InvoiceItem.new(
        sku: item.product.sku,
        description: item.product.name_da,
        price: item.product.cost_price,
        quantity: item.quantity,
      )
    end
  end


end
