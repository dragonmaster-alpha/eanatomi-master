class ProductSale
  include ActiveModel::Model
  attr_accessor :product_id, :from, :to

  def from
    if @from
      Date.parse(@from)
    else
      30.day.ago.to_date
    end
  end

  def to
    if @to
      Date.parse(@to)
    else
      Date.today
    end
  end

  def product?
    product
  end

  def total_quantity
    sales.pluck(:quantity).sum
  end

  def net_totals
    orders.pluck(:market_id).uniq.compact.map do |market_id|
      market = Market.fetch(market_id)
      [market, sales(market: market).map(&:net_amount).sum]
    end
  end

  def product
    @_product ||= Product.find_by(id: @product_id)
  end

  def sales(market: nil)
    OrderItem.joins(:order).merge(orders(market: market)).where(product: product).order(:created_at)
  end

  def orders(market: nil)
    scope = Order.where(status: [1,2,3,4,5,6]).where("placed_at > ?", from).where("placed_at < ?", to + 1.day)
    scope = scope.where(market_id: market.key) if market
    scope
  end


end
