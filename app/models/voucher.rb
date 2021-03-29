class Voucher < ApplicationRecord
  has_many :lines, class_name: 'VoucherLine'
  has_many :orders

  validates_associated :lines
  validates :code, presence: true, uniqueness: true

  accepts_nested_attributes_for :lines, allow_destroy: true, reject_if: lambda { |attributes| attributes['product_id'] == '0' }
end
