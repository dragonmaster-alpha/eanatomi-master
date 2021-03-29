class ShippingEvent < ApplicationRecord
  belongs_to :order

  enum status: {
    received: 2,
    ready_to_pick: 3,
    picking_started: 4,
    shipped_complete: 5,
    shipped_incomplete: 6,
    waiting: 7,
    cancelled: 10
  }

  default_scope -> { order(:occurred_at) }
end
