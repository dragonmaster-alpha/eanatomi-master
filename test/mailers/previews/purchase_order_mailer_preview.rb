# Preview all emails at http://localhost:3000/rails/mailers/purchase_order_mailer
class PurchaseOrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/purchase_order_mailer/restock
  def restock
    PurchaseOrderMailer.restock(PurchaseOrder.build(Manufacturer.find_by(name: "eAnatomi")))
  end

end
