class Postnord::Shipment::Status
  attr_accessor :code, :text, :description

  def initialize(attributes={})
    attributes.each_pair do |key, val|
      self.send "#{key}=", val
    end
  end

  def to_s
    text
  end

  def informed?
    code == 'INFORMED'
  end

  def en_route?
    code == 'EN_ROUTE'
  end

  def delivered?
    code == 'DELIVERED'
  end

end