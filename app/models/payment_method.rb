class PaymentMethod
  attr_accessor :id, :availability, :photo, :needs_confirmation

  PAYMENT_METHODS = {
    dk: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card_dk.png',
        platforms: [:mobile, :desktop]
      },
       mobilepay: {
        availability: ['private', 'business', 'public'],
        photo: 'mobilepay.png',
        platforms: [:mobile, :desktop]
      },
      ean_invoice: {
        availability: ['business', 'public'],
        photo: 'ean_invoice.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    se: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      vat_invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      },
      klarna: {
        availability: [],
        photo: 'klarna.png',
        platforms: [:desktop]
      }
    },
    no: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    local_no: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    gl: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    fo: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    is: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    fi: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      },
      invoice: {
        availability: ['business', 'public'],
        photo: 'vat_invoice.png',
        platforms: [:mobile, :desktop]
      }
    },
    de: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      }
    },
    com: {
      credit_card: {
        availability: ['private', 'business', 'public'],
        photo: 'credit_card.png',
        platforms: [:mobile, :desktop]
      }
    }
  }.freeze

  def initialize(id, args={})
    @id = id
    args.each do |k, v|
      instance_variable_set "@#{k}", v
    end
  end

  def supports?(platform)
    @platforms.include? platform
  end

  def photo?
    defined?(@photo)
  end

  def market
    Market.fetch(@market_id)
  end


  def self.default(market_id)
    PaymentMethod.new(*PAYMENT_METHODS[market_id].first)
  end

  def self.all(market_id, platform: nil)
    methods = PAYMENT_METHODS[market_id.to_sym].map do |k, v|
      PaymentMethod.new(k, v.merge(market_id: market_id))
    end

    if platform
      methods.select! { |m| m.supports?(platform) }
    end

    methods.select! { |m| m.availability.any? }

    methods
  end

  def self.find(market_id, id)
    PaymentMethod.new id.to_sym, PAYMENT_METHODS[market_id][id.to_sym]
  end

end
