module Amountable

  def net_amount
    currency_amount.net_amount
  end

  def net_amount_in_cents
    currency_amount.net_amount_in_cents
  end

  def gross_amount
    currency_amount.gross_amount
  end

  def vat_amount
    currency_amount.vat_amount
  end

  def net_price
    currency_price.net_amount
  end

  def gross_price
    currency_price.gross_amount
  end

  def vat_price
    currency_price.vat_amount
  end

  private

    def currency_price
      Currency.new(price, rate, vat)
    end

    def currency_amount
      Currency.new(amount, rate, vat)
    end

end
