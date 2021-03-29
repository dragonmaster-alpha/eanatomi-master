class Payment < ApplicationRecord
  belongs_to :order

  enum status: {
    authorized: 0,
    captured: 1
  }
end
