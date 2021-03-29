class OldDeliveryMethod
  attr_accessor :id, :cost, :availability, :couriers

  DELIVERY_METHODS = {
    dk: {
      droppoint: {
        cost: 28,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord', 'gls']
      },
      door: {
        cost: 48,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      },
      delivery_address: {
        cost: 48,
        availability: [],
        couriers: []
      }
    },
    se: {
      droppoint: {
        cost: 30,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      },
      door: {
        cost: 72,
        availability: ['business', 'public'],
        couriers: ['postnord']
      },
      delivery_address: {
        cost: 80,
        availability: [],
        couriers: []
      }
    },
    no: {
      droppoint: {
        cost: 68,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      },
      door: {
        cost: 112,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      },
      pickup: {
        cost: 48,
        availability: [],
        couriers: []
      },
    },
    gl: {
      door: {
        cost: 500,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      }
    },
    fo: {
      door: {
        cost: 500,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      }
    },
    is: {
      door: {
        cost: 500,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      }
    },
    fi: {
      door: {
        cost: 500,
        availability: ['private', 'business', 'public'],
        couriers: ['postnord']
      }
    }
  }.freeze

  def self.migrate!
    Market.all.each do |market|
      OldDeliveryMethod.for_market(market.key).each do |delivery_method|
        DeliveryMethod.create!(
          market: market,
          key: delivery_method.key,
          cost: delivery_method.cost,
          availability: delivery_method.availability,
          couriers: delivery_method.couriers,
        )
      end
    end
  end

  def initialize(id, args={})
    @id = id
    args.each do |k, v|
      instance_variable_set "@#{k}", v
    end
  end

  def key
    id
  end

  def market
    Market.fetch(@market_id)
  end

  def self.cheapest(market_id)
    for_market(market_id.to_sym).sort_by(&:cost).first
  end


  def self.default(market_id)
    OldDeliveryMethod.new(*DELIVERY_METHODS[market_id.to_sym].first)
  end

  def self.for_market(market_id)
    DELIVERY_METHODS[market_id.to_sym].map do |k, v|
      OldDeliveryMethod.new(k, v.merge(market_id: market_id))
    end
  end

  def self.fetch(market_id, id)
    if DELIVERY_METHODS[market_id.to_sym][id.to_sym]
      OldDeliveryMethod.new id.to_sym, DELIVERY_METHODS[market_id.to_sym][id.to_sym]
    end
  end

end
