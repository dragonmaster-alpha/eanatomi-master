module Shiphero

  def self.api_key
    ENV['SHIPHERO_API_KEY']
  end


  class RequestError < StandardError
  end

end
