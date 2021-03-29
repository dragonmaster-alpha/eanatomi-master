# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/invoice
  def shipped
    OrderMailer.shipped(Order.find("1c3d41eb-9e29-42ee-b825-32ad981f8db8"))
  end

  def invoice
    OrderMailer.invoice(Invoice.last.order)
  end

  def customs_invoice
    OrderMailer.customs_invoice(Order.last, StringIO.new)
  end

  def pickup
    OrderMailer.pickup(Order.find("1c3d41eb-9e29-42ee-b825-32ad981f8db8"))
  end

  def share
    OrderMailer.share(recipient: 'aske@deeco.dk', message: 'Hej Aske', order: Order.last, sender: 'foo@bar.com')
  end

  def confirmation
    # OrderMailer.confirmation(Order.find("1c3d41eb-9e29-42ee-b825-32ad981f8db8"))
    OrderMailer.confirmation(Order.placed.first)
  end

  def payment
    OrderMailer.payment(Order.find("5597eb0f-3642-49bd-8dd8-d8b0c36a2cb3"))
  end

  def first_waiting_notice
    OrderMailer.first_waiting_notice(Order.find("1c3d41eb-9e29-42ee-b825-32ad981f8db8"))
  end

  def second_waiting_notice
    OrderMailer.second_waiting_notice(Order.find("5597eb0f-3642-49bd-8dd8-d8b0c36a2cb3"))
  end

  def third_waiting_notice
    OrderMailer.third_waiting_notice(Order.find("5597eb0f-3642-49bd-8dd8-d8b0c36a2cb3"))
  end

end
