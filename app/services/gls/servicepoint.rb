class GLS::Servicepoint
  attr_accessor :id, :name, :distance, :street, :city, :hours, :zip_code, :country_code

  def initialize(attrs={})
    attrs.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def hours
    []
  end

  def self.build(result)
    self.new(
      id: result.at_css('Number').text,
      name: result.at_css('CompanyName').text,
      street: result.at_css('Streetname').text,
      zip_code: result.at_css('ZipCode').text,
      city: result.at_css('CityName').text,
      distance: result.at_css('DistanceMetersAsTheCrowFlies').text,
      country_code: result.at_css('CountryCodeISO3166A2').text
    )
  end

  def self.find(zip_code:, country_code:, street: '', limit: 10)
    url = 'http://www.gls.dk/webservices_v4/wsShopFinder.asmx/SearchNearestParcelShops'

    data = {
      zipcode: zip_code,
      street: street,
      'Amount': limit,
      'countryIso3166A2': country_code
    }

    response = with_retries(max_tries: 3) do
      HTTP.post(url, form: data)
    end
    doc = Oga.parse_xml(response.to_s)
    doc.css('PakkeshopData').map do |result|
      pp result
      self.build result
    end
  end

end
