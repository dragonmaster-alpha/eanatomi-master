class Shipment < ApplicationRecord
  belongs_to :order

  def distributor
    super || order.courier
  end

  def distributor_by_code_length
    if code.size == 12
      'gls'
    elsif code.size == 20
      'postnord'
    elsif code.size == 18
      'bring'
    end
  end
end
