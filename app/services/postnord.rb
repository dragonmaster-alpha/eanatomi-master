module Postnord

  def self.resource(path, options={})
    options[:apikey] = ENV['POSTNORD_API_KEY']

    params = {}

    options.each do |k, v|
      params[k.to_s.camelcase(:lower)] = v
    end

    Http.get("https://api2.postnord.com/#{path}", params: params)

  end

  class TimeoutError < StandardError
  end
end
