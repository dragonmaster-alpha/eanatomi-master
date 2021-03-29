class User < ApplicationRecord
  include Clearance::User

  has_many :orders, dependent: :nullify
  has_many :vendor_prices, dependent: :destroy
  has_many :object_changes, dependent: :nullify

  accepts_nested_attributes_for :vendor_prices, allow_destroy: true, reject_if: lambda { |attributes| attributes['product_id'] == '0' }

  enum role: {
    customer: 0,
    admin: 1,
    vendor: 2,
    translator: 3
  }

  def show_vat?
    client_type == 'private'
  end

  def flipper_id
    email
  end

  def client_type
    super || 'private'
  end


  def market
    @_market ||= Market.fetch(market_id)
  end

  def market_id
    super || 'dk'
  end

  def to_s
    name || email || super
  end

end
