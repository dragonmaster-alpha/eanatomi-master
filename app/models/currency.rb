class Currency

  def initialize(base, rate, vat)
    @base = BigDecimal(base.to_s.presence || 0)
    @rate = BigDecimal(rate.to_s.presence || 0)
    @vat  = BigDecimal(vat.to_s.presence || 0)
  end

  def self.calculate_base(net_amount, rate, vat)
    net_amount = BigDecimal(net_amount.to_s.presence || 0)
    rate = BigDecimal(rate.to_s.presence || 0)
    vat = BigDecimal(vat.to_s.presence || 0)

    (net_amount / ( 1 + vat )) * rate
  end

  def vat_amount
    gross_amount * @vat
  end

  def net_amount
    gross_amount + vat_amount
  end

  def net_amount_in_cents
    (net_amount * BigDecimal('100')).to_i
  end

  def to_s
    gross_amount.to_s
  end

  def gross_amount
    return BigDecimal(0) if @rate.zero?
    BigDecimal(@base / @rate).round
  end

end
