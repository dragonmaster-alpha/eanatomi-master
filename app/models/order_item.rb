class OrderItem < ActiveRecord::Base
  include Sortable
  include Amountable

  belongs_to :order
  belongs_to :product, optional: true

  has_many :volume_prices, through: :product

  after_save :remove_empty
  default_scope -> { order(:created_at) }
  delegate :vat, :rate, to: :order
  delegate :category, to: :product

  def amount
    sales_price * quantity
  end

  def has_components?
    component_ids&.any?
  end

  def components
    Product.where(id: component_ids)
  end

  def in_stock?
    if in_stock_cache.nil?
      product.presumable_stock.to_i >= quantity
    else
      in_stock_cache
    end
  end

  def product
    super || NilProduct.new
  end

  def voucher_line
    @_voucher_line ||= order.voucher_lines.find_by(product: product) || VoucherLine.new
  end

  def sales_price
    super || volume_price&.price || voucher_line.price || price || 0
  end

  def volume_price
    volume_prices.sorted.where('quantity <= ?', quantity).last
  end

  def net_before_price
    Currency.new(price, order.rate, order.vat).net_amount
  end

  def gross_price
    Currency.new(sales_price, order.rate, order.vat).gross_amount
  end

  def net_price
    Currency.new(sales_price, order.rate, order.vat).net_amount
  end

  def gross_amount
    Currency.new(amount, order.rate, order.vat).gross_amount
  end

  def net_amount
    Currency.new(amount, order.rate, order.vat).net_amount
  end

  def to_s
    name
  end

  def remove_empty
    self.destroy if self.quantity.to_i < 1
  end

  def lock_sales_price!
    self.update! sales_price: sales_price
  end

end
