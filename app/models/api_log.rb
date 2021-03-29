class ApiLog < ApplicationRecord

  scope :service, -> (service) { where(service: service) }

  scope :successful, -> { where('response_code LIKE ?', '2%') }
  scope :failed, -> { where.not('response_code LIKE ?', '2%') }

  def print
    puts format
  end

  def format
    <<~FORMAT
      #{method} #{url}
      #{request_body}

      => #{response_code}
      #{response_body}
    FORMAT
  end

  def self.log_request(service, method, url, request_body: nil)
    if request_body.is_a?(Hash)
      request_body = request_body.to_json
    end

    response = yield
    create(service: service, method: method.upcase, url: url, request_body: request_body, response_code: response.code, response_body: response.body)
    response
  end

end
