class ShipmentDecorator < Draper::Decorator
  delegate_all

  def url
    case distributor.to_s.downcase
    when 'bring'
      bring_url
    when 'postnord'
      postnord_url
    when 'gls'
      gls_url
    when 'ups'
      ups_url
    else
      "http://tracking.dansk-e-logistik.dk/track?number=#{code}"
    end
  end

  private

  def bring_url
    case order.market.key
    when :se
      "https://tracking.bring.se/tracking.html?q=#{code}"
    when :no
      "https://tracking.bring.no/tracking.html?q=#{code}"
    else
      "https://tracking.bring.dk/tracking.html?q=#{code}"
    end
  end

  def postnord_url
    case order.market.key
    when :se
      "https://tracking.postnord.com/se/?id=#{code}"
    when :no
      "https://tracking.postnord.com/no/?id=#{code}"
    else
      "https://tracking.postnord.com/dk/?id=#{code}"
    end
  end

  def gls_url
    case order.market.key
    when :dk
      "https://gls-group.eu/DK/da/find-pakke?match=#{code}"
    else
      "https://gls-group.eu/EU/en/parcel-tracking?match=#{code}"
    end
  end

  def ups_url
    case order.market.key
    when :no
      "https://www.ups.com/track?loc=no_NO&tracknum=#{code}"
    else
      "https://www.ups.com/track?loc=da_DK&tracknum=#{code}"
    end
  end

end
