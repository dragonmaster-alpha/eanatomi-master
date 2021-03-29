class OrderMailer < ApplicationMailer

  def confirmation(order)
    I18n.locale = order.market.locale

    @order = order.decorate

    mail to: @order.email, bcc: 'info@eanatomi.dk', subject: default_i18n_subject(order_number: @order.order_number)
  end

  def payment(order)
    I18n.locale = order.market.locale

    @order = order.decorate
    @payment_link = order_payment_url(order)

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def shipped(order)
    I18n.locale = order.market.locale

    @order = order.decorate
    @shipments = order.shipments.decorate

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def invoice(order)
    I18n.locale = order.market.locale

    @order = order.decorate

    attachments['faktura.pdf'] = order.invoice.file.read

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def share(recipient:, message: nil, order:, sender: nil)
    I18n.locale = order.market.locale

    @message = message
    @order = order.decorate

    mail to: recipient, reply_to: sender
  end

  def share_confirmation(recipient:, message: nil, order:, sender: nil)
    I18n.locale = order.market.locale

    @recipient = recipient
    @message = message
    @order = order.decorate

    mail to: sender
  end

  def customs_invoice(order, pdf)
    @order = order.decorate
    attachments["#{@order.order_number}.pdf"] = pdf.read
    mail to: ' faktura@ups.com', bcc: 'info@eanatomi.dk, eanatomias@ebilag.com', subject: "Fortoldnings faktura #{@order.order_number}.pdf"
  end

  def first_waiting_notice(order)
    I18n.locale = order.market.locale
    @order = order.decorate
    @out_of_stock_items = @order.order_items.select { |item| !item.in_stock? }

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def second_waiting_notice(order)
    I18n.locale = order.market.locale
    @order = order.decorate
    @out_of_stock_items = @order.order_items.select { |item| !item.in_stock? }

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def third_waiting_notice(order)
    I18n.locale = order.market.locale
    @order = order.decorate
    @out_of_stock_items = @order.order_items.select { |item| !item.in_stock? }

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

  def pickup(order)
    I18n.locale = order.market.locale
    @order = order.decorate
    @shipments = order.shipments.decorate

    mail to: @order.email, bcc: 'info@eanatomi.dk'
  end

end
