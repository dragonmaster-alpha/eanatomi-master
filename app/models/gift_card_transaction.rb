class GiftCardTransaction < ApplicationRecord
  belongs_to :order
  belongs_to :gift_card

  after_create :ensure_status

  def ensure_status
    gift_card.ensure_status!
  end

end
