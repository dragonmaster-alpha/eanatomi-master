class Logistics::OrderInvoiceInformation
  attr_accessor :delivery_name, :delivery_address, :delivery_zip, :delivery_city, :delivery_country, :delivery_attention, :customer_number, :shipping_form, :email, :phone, :delivery_instructions, :delivery_place_id, :delivery_place_name, :delivery_place_address, :delivery_place_zip_code, :delivery_place_city, :delivery_place_country, :courier

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def serialize
    {
      'order:CustomerNumber'       => customer_number,
      'order:DeliveryAddress'      => delivery_address,
      'order:DeliveryAttention'    => delivery_attention,
      'order:DeliveryCity'         => delivery_city,
      'order:DeliveryCountry'      => delivery_country,
      'order:DeliveryInstructions' => delivery_instructions,
      'order:DeliveryName'         => delivery_name,
      'order:DeliveryPlaceAddress' => delivery_place_address,
      'order:DeliveryPlaceCity'    => delivery_place_city,
      'order:DeliveryPlaceCountry' => delivery_place_country,
      'order:DeliveryPlaceId'      => delivery_place_id.to_i,
      'order:DeliveryPlaceName'    => delivery_place_name,
      'order:DeliveryPlaceZipCode' => delivery_place_zip_code,
      'order:DeliveryZip'          => delivery_zip,
      'order:Email'                => email,
      'order:Phone'                => phone,
      'order:ShippingForm'         => shipping_code
    }
  end

  private

    def shipping_code
      data = {
        'default' => {
          'nearest'      => '1002', # Privat uden omdeling
          'standard'     => '1003', # Privat med omdeling
          'business'     => '1004', # Erhverv
        },
        'postnord' => {
          'nearest'      => '102', # Privat uden omdeling
          'standard'     => '103', # Privat med omdeling
          'business'     => '104', # Erhverv
          'flex'         => '105', # Privat FLEX levering
          'servicepoint' => '106', # Pakkeboks/PostButik
        },
        'gls' => {
          'nearest'      => '702', # GLS UOMD
          'standard'     => '103', # Brug i stedet Postnord privat med omdeling
          # 'standard'     => '703', # GLS OMD PRIVAT
          'business'     => '704', # GLS OMD
          'servicepoint' => '706', # GLS Pakkeshop
          'flex'         => '707', # GLS depositservice
        },
        'ups' => {
          'nearest'      => '950',
          'standard'     => '950',
          'business'     => '950',
          'flex'         => '950',
          # 'servicepoint' => nil,
        }
      }

      data.fetch(courier, data['default']).fetch(shipping_form)
    end

end
