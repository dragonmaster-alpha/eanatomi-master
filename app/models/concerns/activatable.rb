module Activatable
  extend ActiveSupport::Concern

  included do
    has_one :active_in_market, as: :activatable


    before_save :ensure_active_in_market

    scope :active_in, -> (market) { joins(:active_in_market).merge(ActiveInMarket.active_in(market)) }
    scope :active_in_markets, -> { joins(:active_in_market).merge(ActiveInMarket.active_in_markets) }
    scope :inactive_in_markets, -> { joins(:active_in_market).merge(ActiveInMarket.inactive_in_markets) }

    accepts_nested_attributes_for :active_in_market

    delegate :active_status, :active_status=, :active_markets, :active_in_market?, to: :active_in_market
  end


  private

  def ensure_active_in_market
    self.active_in_market ||= ActiveInMarket.new
  end

end
