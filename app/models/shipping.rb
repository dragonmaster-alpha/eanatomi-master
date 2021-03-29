class Shipping
  delegate :available_for_delivery?, :delivered?, to: :shipment

  def initialize(tracking_number, distributor: nil)
    @tracking_number = tracking_number
    @distributor = distributor
  end

  def shipment
    case @distributor
    when 'gls'
      @_shipment ||= GLS::Shipment.find(@tracking_number) || GLS::Shipment.new
    when 'postnord'
      @_shipment ||= Postnord::Shipment.find(@tracking_number) || Postnord::Shipment.new
    else
      Postnord::Shipment.new
    end
  end

end
