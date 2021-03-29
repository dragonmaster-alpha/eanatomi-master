class OrderLog < ApplicationRecord
  belongs_to :order

  default_scope -> { order(:created_at) }
end
