class VolumePrice < ApplicationRecord
  belongs_to :product, touch: true
  translates

  scope :sorted, -> { order(:quantity) }

end
