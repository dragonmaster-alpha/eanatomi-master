class Accounting::Economic::Customer < Accounting::Base::Customer


  # required: currency, customerGroup.customerGroupNumber, vatZone.vatZoneNumber, name, paymentTerms.paymentTermsNumber
  def serialize
    {
      name: name.to_s,
      currency: currency_code.to_s,
      phone: phone.to_s,
      email: email.to_s,
      address: address.to_s,
      address2: address2.to_s,
      city: city.to_s,
      zip: zip.to_s,
      country: country.to_s,
      corporateIdentificationNumber: vat_number.to_s,
      customerGroup: {
        customerGroupNumber: group_id
      },
      vatZone: {
        vatZoneNumber: vat_zone_id
      },
      paymentTerms: {
        paymentTermsNumber: payment_terms_id
      }
    }
  end

  def save!
    result = Accounting::Economic::Client.new.post('customers', self.serialize)
    @id = result.body["customerNumber"]
    self
  end

  def self.find(id)
    result = Accounting::Economic::Client.new.get("customers/#{id}")
    self.new(
      id: id,
      name: result.body['name'],
      currency_code: result.body['currency'],
      phone: result.body['phone'],
      email: result.body['email'],
      address: result.body['address'],
      address2: result.body['address2'],
      city: result.body['city'],
      zip: result.body['zip'],
      country: result.body['country'],
      vat_number: result.body['corporateIdentificationNumber'],
      group_id: result.body['customerGroup']['customerGroupNumber'],
      vat_zone_id: result.body['vatZone']['vatZoneNumber'],
      payment_terms_id: result.body['paymentTerms']['paymentTermsNumber'],
      layout_id: result.body['layout']['layoutNumber'],
    )
  end

  def market
    Market.fetch(@market)
  end

    # private

    def vat_zone_id
      @vat_zone_id || if market.eu?
        vat ? 1 : 2
      else
        3
      end
    end

    def currency_code
      @currency_code || {
        :dk => 'DKK',
        :no => 'NOK',
        :se => 'SEK',
        :gl => 'DKK',
        :fi => 'EUR',
      }.fetch(market.key, 'DKK')
    end

    def group_id
      @group_id || {
        :dk => 1,
        :se => 2,
        :no => 3,
        :gl => 3,
        :fi => 3,
      }.fetch(market.key, 1)
    end

    def payment_terms_id
      return 2 if Rails.env.development?

      @payment_terms_id || {
        :dk => {
          'credit_card' => 26,
          'mobilepay'   => 26,
          'invoice'     => 1,
          'ean_invoice' => 24
        },
        :se => {
          'credit_card' => 26,
          'invoice'     => 21,
          'vat_invoice' => 21,
          'klarna'      => 27
        },
        :no => {
          'credit_card' => 26,
          'invoice'     => 4
        },
        :gl => {
          'credit_card' => 26,
          'invoice'     => 4
        },
        :fi => {
          'credit_card' => 26,
          'invoice'     => 4
        }
      }.fetch(market.key).fetch(payment_type)
    end

    def layout_id
      @layout_id
    end

end
