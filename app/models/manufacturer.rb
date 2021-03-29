class Manufacturer < ApplicationRecord
  has_many :products

  scope :restocking, -> { where.not(restocking_interval: nil) }
  scope :due_for_purchase_order, -> { restocking.where(last_purchase_order_on: nil).or(
    restocking.where('last_purchase_order_on < current_date - restocking_interval + 1')) }

  def restocking_on
    if last_purchase_order_on
      last_purchase_order_on + restocking_interval
    else
      Date.today
    end
  end

  def option_name
    name
  end

  def to_s
    name || super
  end
end
