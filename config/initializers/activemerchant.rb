if Rails.env.development?
  ActiveMerchant::Billing::Base.mode = :test
end
