class ShippingTime < ApplicationRecord
  has_many :products
  translates :description, accessors: I18n.available_locales

  def to_s
    description || super
  end

  def option_name
    description
  end

  def self.default
    find(10)
  end

end
