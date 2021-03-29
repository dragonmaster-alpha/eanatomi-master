class Market < ApplicationRecord
  include Sortable
  
  scope :active, -> { where(active: true) }

  def self.by_domain(domain)
    domain.gsub!('dev.', '')
    domain.gsub!('.lvh.me', '')
    domain.gsub!('localhost', 'eanatomi.dk')
    domain.gsub!('eanatomi-deeco.fwd.wf', 'eanatomi.dk')

    if market = self.where("domain LIKE ?", "%#{domain}%").first
      market
    else
      raise NotFoundError, "market domain #{domain} not found"
    end
  end

  def self.fetch(key)
    if market = self.find_by(key: key)
      market
    else
      raise NotFoundError, "market with key #{key} not found"
    end
  end

  def accounting_class
    super.constantize
  end

  def warehouse
    ActiveSupport::Deprecation.warn('please use Rails.application.warehouse')
    Rails.application.warehouse
  end

  def couriers
    ActiveSupport::Deprecation.warn('please use DeliveryMethod.available_couriers')
    DeliveryMethod.available_couriers
  end

  def lang
    locale
  end

  def key
    super.to_sym
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
      "https://#{domain}"
    else
      "http://#{domain}.lvh.me:3000"
    end
  end

  def to_partial_path
    'market'
  end

  def to_s
    key.to_s
  end

  class NotFoundError < StandardError
  end

end
