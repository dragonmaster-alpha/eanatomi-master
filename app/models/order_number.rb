class OrderNumber

  PREFIX = ENV['ORDER_NUMBER_PREFIX'].to_s

  def self.next
    numbers = Order.unscoped.pluck("MAX(CAST(substring(order_number from '[0-9]+') as integer))")
    new(numbers.first.to_i.next)
  end

  def initialize(number)
    @number = number.to_s.remove(PREFIX)
  end

  def to_s
    "#{PREFIX}#{@number}"
  end

end
