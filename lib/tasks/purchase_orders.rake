namespace :purchase_orders do

  desc "Sends purchase_orders"
  task send: :environment do
    Manufacturer.due_for_purchase_order.each do |manufacturer|
      order = PurchaseOrder.build(manufacturer)

      if order.items.any?
        order.save!
        manufacturer.update last_purchase_order_on: Time.zone.today
        PurchaseOrderMailer.restock(order).deliver_later
      end
    end
  end

end
