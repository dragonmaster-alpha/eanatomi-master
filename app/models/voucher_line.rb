class VoucherLine < ApplicationRecord
  belongs_to :voucher
  belongs_to :product

  validates :product, presence: true
  validates :price, presence: true
end
