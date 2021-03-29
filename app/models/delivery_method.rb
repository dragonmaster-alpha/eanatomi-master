class DeliveryMethod < ApplicationRecord
  include Sortable
  belongs_to :market

  def to_s
    key
  end

  scope :available, -> { where.not(availability: []) }
  scope :for_market, -> (market_key) { available.where(market: Market.find_by(key: market_key)).sorted }

  def self.cheapest(market_key)
    for_market(market_key).order(:cost).first
  end

  def self.default(market_key)
    for_market(market_key).sorted.first
  end

  def self.fetch(market_key, key)
    find_by(market: Market.find_by(key: market_key), key: key)
  end

  def self.available_couriers
    pluck(:couriers).flatten.map.uniq
  end

  def self.available_options
    sorted.pluck(:key).flatten.map.uniq
  end

  def availability_list
    Array(availability).join(', ')
  end

  def availability_list=(val)
    self.availability = val.to_s.split(',').map(&:strip).compact
  end

  def couriers_list
    Array(couriers).join(', ')
  end

  def couriers_list=(val)
    self.couriers = val.to_s.split(',').map(&:strip).compact
  end

end
