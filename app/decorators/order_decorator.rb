class OrderDecorator < Draper::Decorator
  delegate_all
  decorates_association :order_items

  def phone_prefix
    market.phone_prefix
  end

  def status_class
    if order.failures.unseen.any?
      'danger'
    elsif order.needs_review?
      'warning'
    end
  end

  def phone_number
    "#{phone_prefix} #{phone}"
  end

  def shipment_ids
    shipments.map(&:code).join(', ')
  end

end
