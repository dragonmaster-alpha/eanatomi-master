class GiftCardNumber

  PREFIX = ENV['GIFT_CARD_NUMBER_PREFIX'].to_s

  def self.next
    numbers = GiftCard.unscoped.pluck("MAX(CAST(substring(card_number from '[0-9]+') as integer))")
    new(numbers.first.to_i.next)
  end

  def initialize(number)
    @number = number.to_s.remove(PREFIX)
  end

  def to_s
    "#{PREFIX}#{@number}"
  end

end
