class Postnord::Servicepoint
  attr_accessor :id, :name, :distance, :street, :city, :hours, :zip_code, :country_code

  def self.find(zip_code:, limit: 10, street: nil, country_code: 'DK', locale: 'da')
    options = {
      'postalCode' => zip_code,
      'streetName' => street,
      'numberOfServicePoints' => limit,
      'countryCode' => country_code,
      'locale' => locale
    }

    begin
      response = Postnord.resource('rest/businesslocation/v1/servicepoint/findNearestByAddress.json', options)
    rescue RestClient::BadRequest, URI::InvalidURIError => e
      return []
    end


    JSON.parse(response)['servicePointInformationResponse']['servicePoints'].map do |json|
      self.from_json json
    end
  end

  def self.from_json(json)
    self.new.tap do |point|
      point.id = json['servicePointId']
      point.name = json['name']
      point.distance = json['routeDistance']
      point.street = "#{json['deliveryAddress']['streetName']} #{json['deliveryAddress']['streetNumber']}"
      point.zip_code = json['deliveryAddress']['postalCode']
      point.country_code = json['deliveryAddress']['countryCode']
      point.city = json['deliveryAddress']['city'].capitalize
      point.hours = Hour.from_json json['openingHours']
    end
  end

end
