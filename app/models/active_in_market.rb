class ActiveInMarket < ApplicationRecord
  belongs_to :activatable, polymorphic: true

  MARKETS = %i( dk se no local_no gl fo is fi de com ).freeze

  def activate!
    MARKETS.each do |market|
      self.send("#{market}=", true)
    end
    self
  end

  scope :inactive_in_markets, -> do
    query = MARKETS.map do |market|
      [market, [false, nil]]
    end.to_h

    where(query)
  end

  scope :active_in, -> (market) do
    where(market => true)
  end

  scope :active_in_markets, -> do
    where(dk: true).or(
      where(se: true).or(
        where(no: true).or(
          where(local_no: true).or(
            where(fo: true).or(
              where(is: true).or(
                where(fi: true).or(
                  where(de: true).or(
                    where(com: true)
                  )
                )
              )
            )
          )
        )
      )
    )
  end

  def active_in_market?(market)
    active_markets.include? market.to_sym
  end

  def active_status
    active_markets.any? ? 'active' : 'inactive'
  end

  def active_status=(val)
  end

  def active_markets
    MARKETS.map do |market|
      market if self.send(market)
    end.compact
  end

end
