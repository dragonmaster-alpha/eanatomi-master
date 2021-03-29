class GLS::Shipment
  attr_accessor :status, :events, :sender, :tracking_number

  def available_for_delivery?
    @status == '3.124'
  end

  def delivered?
    @status == '3.0'
  end

  def self.find(tracking_number)
    body = self.client.call(:get_tu_detail, message: {
        'ns1:RefValue' => tracking_number,
        'ns1:Credentials' => {
          'ns1:UserName' => '2080060960',
          'ns1:Password' => 'API1234'
        }
    }).body

    events = body.dig(:tu_details_response, :history).map do |event_body|
      GLS::Shipment::Event.from_body(event_body)
    end

    self.new.tap do |shipment|
      shipment.tracking_number = tracking_number
      shipment.events = events
      shipment.sender = body.dig(:tu_details_response, :shipper_address)
      shipment.status = events.first.status
    end
  end

  def self.client
    Savon.client(
      wsdl: "http://www.gls-group.eu/276-I-PORTAL-WEBSERVICE/services/Tracking/wsdl/Tracking.wsdl",
      logger: Rails.logger,
      log_level: :debug,
      log: true,
      namespaces: {
        'xmlns:ns1' => 'http://gls-group.eu/Tracking/'
      }
    )
  end

end
