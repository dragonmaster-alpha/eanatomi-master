class Postnord::Shipment
  attr_accessor :status, :events, :sender, :tracking_number

  def available_for_delivery?
    status&.code == 'AVAILABLE_FOR_DELIVERY'
  end

  def delivered?
    status&.code == 'DELIVERED'
  end

  def self.find(tracking_number)
    response = Postnord.resource('rest/shipment/v1/trackandtrace/findByIdentifier.json', id: tracking_number)
    shipments = JSON.parse(response)['TrackingInformationResponse']['shipments']

    if shipments&.any?
      shipment = self.from_json(shipments.first)
      shipment.tracking_number = tracking_number
      shipment
    else
      nil
    end
  end

  def self.from_json(json)
    self.new.tap do |shipment|
      shipment.sender = json.dig('consignor', 'name')
      shipment.status = Status.new code: json['status'], text: json['statusText']['header'], description: json['statusText']['body']

      shipment.events = json['items'].first['events'].map do |event_json|
        Event.from_json event_json
      end
    end
  end

  def updated_at
    @_updated_at ||= begin
      events.first&.date_time
    end
  end
end
