class Destination
  attr_accessor :accounting_class, :notice, :id, :currency, :locale, :eu,
                :domain, :timezone, :rate, :vat, :country, :analytics_id,
                :clearance_fee, :delivery_sku, :delivery_id, :clearance_sku,
                :clearance_id, :gift_card_sku, :gift_card_id,
                :google_site_verification, :country_code, :customs_invoice,
                :phone_prefix, :free_shipping, :active, :shipping_provider,
                :choose_servicepoint, :blog_url, :google_merchant_id,
                :couriers, :warehouse

  DESTINATIONS = {
    dk: {
      locale: 'da',
      currency: 'dkk',
      country: 'Danmark',
      country_code: 'DK',
      domain: 'www.eanatomi.dk',
      timezone: 'Copenhagen',
      rate: 1,
      vat: 0.25,
      analytics_id: 'UA-24261947-1',
      delivery_sku: 'fragt',
      gift_card_sku: 'GKEA',
      google_site_verification: 'BdfAKlhndvl5-aBsllIeFnQaqKLcxuHMAHSW2mchIoo',
      google_merchant_id: '112093313',
      phone_prefix: '+45',
      free_shipping: false,
      eu: true,
      active: true,
      accounting_class: Accounting::Economic,
      shipping_provider: 'postnord',
      couriers: ['postnord', 'gls'],
      choose_servicepoint: true,
      blog_url: 'https://blog.eanatomi.dk',
      warehouse: 'e-logistik'
    },
    se: {
      locale: 'sv',
      currency: 'sek',
      country: 'Sverige',
      country_code: 'SE',
      domain: 'www.eanatomi.se',
      timezone: 'Stockholm',
      rate: 0.714,
      vat: 0.25,
      analytics_id: 'UA-24261947-2',
      delivery_sku: 'fragt',
      gift_card_sku: 'GKEA',
      google_site_verification: 'Ftarimm9pXq6gXTQGtDStMpRrRoLGYEFR0P7D0emec0',
      phone_prefix: '+46',
      free_shipping: false,
      eu: true,
      active: true,
      accounting_class: Accounting::Economic,
      shipping_provider: 'postnord',
      couriers: ['postnord'],
      choose_servicepoint: true,
      blog_url: 'https://blog.eanatomi.se',
      warehouse: 'e-logistik'
    },
    no: {
      locale: 'nb',
      currency: 'nok',
      country: 'Norge',
      country_code: 'NO',
      domain: 'www.eanatomi.no',
      timezone: 'Copenhagen',
      rate: 0.75,
      vat: 0.25,
      analytics_id: 'UA-24261947-3',
      delivery_sku: 'fragt',
      delivery_id: '23808945',
      gift_card_sku: 'GKEA',
      gift_card_id: '18436638',
      customs_invoice: false,
      phone_prefix: '+47',
      free_shipping: false,
      notice: false,
      active: true,
      accounting_class: Accounting::Tripletex,
      blog_url: 'https://blog.eanatomi.no',
      warehouse: 'shiphero'
    },
    gl: {
      locale: 'da_GL',
      currency: 'dkk',
      country: 'Grønland',
      country_code: 'GL',
      domain: 'gl.eanatomi.dk',
      timezone: 'Copenhagen',
      rate: 1,
      vat: 0,
      analytics_id: 'UA-24261947-1',
      delivery_sku: 'fragt',
      customs_invoice: true,
      phone_prefix: '+299',
      free_shipping: false,
      notice: true,
      active: true,
      accounting_class: Accounting::Economic,
      warehouse: 'e-logistik'
    },
    fo: {
      locale: 'da_FO',
      currency: 'dkk',
      country: 'Færøerne',
      country_code: 'FO',
      domain: 'fo.eanatomi.dk',
      timezone: 'Copenhagen',
      rate: 1,
      vat: 0,
      analytics_id: 'UA-24261947-1',
      delivery_sku: 'fragt',
      customs_invoice: true,
      phone_prefix: '+298',
      free_shipping: false,
      notice: true,
      active: true,
      accounting_class: Accounting::Economic,
      warehouse: 'e-logistik'
    },
    is: {
      locale: 'da_IS',
      currency: 'dkk',
      country: 'Island',
      country_code: 'IS',
      domain: 'is.eanatomi.dk',
      timezone: 'Copenhagen',
      rate: 1,
      vat: 0,
      analytics_id: 'UA-24261947-1',
      delivery_sku: 'fragt',
      customs_invoice: true,
      phone_prefix: '+354',
      free_shipping: false,
      notice: true,
      active: true,
      accounting_class: Accounting::Economic,
      warehouse: 'e-logistik'
    },
    fi: {
      locale: 'fi',
      currency: 'eur',
      country: 'Findland',
      country_code: 'FI',
      domain: 'www.eanatomi.fi',
      timezone: 'Copenhagen',
      rate: 7.44,
      vat: 0,
      analytics_id: '',
      delivery_sku: 'fragt',
      customs_invoice: false,
      phone_prefix: '+358',
      free_shipping: false,
      notice: false,
      eu: true,
      active: false,
      accounting_class: Accounting::Economic,
      warehouse: 'e-logistik'
    }
  }.freeze

  def self.by_domain(domain)
    id, args = DESTINATIONS.find do |id, args|
      domain.include? args[:domain]
    end

    raise NotFoundError, 'not found' unless id

    self.new(id, args)
  end

  def self.find(id)
    self.new id.to_sym, DESTINATIONS[id.to_sym]
  end

  def self.active
    all.select(&:active)
  end

  def self.all
    DESTINATIONS.map do |id, args|
      self.new id, args
    end
  end

  def self.migrate
    DESTINATIONS.map do |id, data|
      data[:key] = id
      Market.create!(data)
    end
  end

  def initialize(id, args={})
    @id = id
    args.each do |k, v|
      instance_variable_set "@#{k}", v
    end
  end

  def lang
    @locale
  end

  def clearance_fee?
    clearance_fee
  end

  def vat?
    vat.nonzero?
  end

  def eu?
    eu
  end

  def notice?
    notice
  end

  def url
    if Rails.env.production?
      "https://#{@domain}"
    else
      "http://#{@domain}.lvh.me:3000"
    end
  end

  def to_partial_path
    'market'
  end

  def to_s
    @id.to_s
  end

  class NotFoundError < StandardError
  end

end
