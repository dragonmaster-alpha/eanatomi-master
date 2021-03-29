class Context::Path
  include Enumerable

  def each(&block)
    @items.each(&block)
  end

  def last
    @items.last
  end

  def initialize
    @items = []
  end

  def add(*items)
    @items += items.to_a
  end

  def has?(item)
    @items.include? item
  end

end
