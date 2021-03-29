class PurchaseOrderMailer < ApplicationMailer
  layout false

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.purchase_order_mailer.restock.subject
  #
  def restock(purchase_order)
    @purchase_order = purchase_order
    @purchase_order.sent!
    mail to: 'info@eanatomi.dk', subject: 'Order for warehouse', from: 'eAnatomi <info@eanatomi.dk>'
  end
end
