class GLS::Shipment::Event
  attr_accessor :date_time, :status, :description, :location

  def self.from_body(body)
    self.new.tap do |event|
      date = body[:date]
      event.date_time = DateTime.new date[:year].to_i, date[:month].to_i, date[:day].to_i, date[:hour].to_i, date[:minut].to_i
      event.description = body[:desc]
      event.location = body[:location_name]
      event.status = body[:code]
    end
  end

end
