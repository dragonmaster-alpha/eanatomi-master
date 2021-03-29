class Postnord::Shipment::Event
  attr_accessor :date_time, :status, :description, :location
  
  def self.from_json(json)
    self.new.tap do |event|
      event.date_time = DateTime.parse json['eventTime']
      event.description = json['eventDescription']
      event.location = json['location']['name']
      event.status = Postnord::Shipment::Status.new code: json['status']
    end
  end

end