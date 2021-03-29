class Invoice < ApplicationRecord
  include FileUploader[:file]

  belongs_to :order, optional: true
  belongs_to :gift_card, optional: true

  enum status: {
    draft: 0,
    booked: 1
  }

end
