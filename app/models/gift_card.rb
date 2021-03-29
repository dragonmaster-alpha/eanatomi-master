class GiftCard < ApplicationRecord
  include FileUploader[:invoice_file]
  include FileUploader[:file]

  has_many :gift_card_transactions
  has_many :orders, through: :gift_card_transactions
  has_one :invoice, dependent: :destroy
  before_create :set_code, :set_expiry, :set_card_number, :set_rate_and_vat

  scope :not_expired, -> { where('expires_at > ?', DateTime.now) }
  scope :active, -> { paid.not_expired }

  enum status: {
    unpaid: 0,
    paid: 1,
    used: 2
  }

  alias_attribute :order_number, :card_number

  def market
    Market.fetch(market_id)
  end

  def payment_method
    'credit_card'
  end

  def net_amount_in_cents
    (net_amount * 100).to_i
  end

  def net_used
    gift_card_transactions.map(&:net_amount).inject(:+) || 0
  end

  def net_available
    net_amount - net_used || 0
  end

  def gross_amount
    Currency.calculate_base(net_amount, rate, vat)
  end

  def net_amount
    super || 0
  end

  def ensure_status!
    self.used! unless net_available > 0
  end

  def accounting_class
    super ? super.constantize : market.accounting_class
  end

  private

  def set_code
    self.code = SecureRandom.hex(4)
  end

  def set_expiry
    self.expires_at = 3.years.from_now
  end

  def set_card_number
    self.card_number = GiftCardNumber.next unless self.card_number
  end

  def set_card_number!
    self.update card_number: GiftCardNumber.next
  end

  def set_rate_and_vat
    self.rate = market.rate
    self.vat = market.vat
  end

  def set_accounting_class
    self.accounting_class = market.accounting_class
  end

end
