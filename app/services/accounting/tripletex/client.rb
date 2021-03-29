class Accounting::Tripletex::Client

  def get(path)
    request do
      path = "#{BASE_URL}/#{path}"
      ApiLog.log_request('tripletex', 'GET', path) { authorized.get(path) }
    end
  end

  def post(path, params)
    request do
      path = "#{BASE_URL}/#{path}"
      ApiLog.log_request('tripletex', 'POST', path, request_body: params) { authorized.post(path, json: params) }
    end
  end

  def put(path, params)
    request do
      path = "#{BASE_URL}/#{path}"
      ApiLog.log_request('tripletex', 'PUT', path, request_body: params) { authorized.put(path, json: params) }
    end
  end

  def get_file(path)
    authorized.get("#{BASE_URL}/#{path}")
  end

  private

  def request
    response = yield.parse
    if response['status']
      raise Accounting::OperationError, response['message']
    else
      response
    end
  end

  BASE_URL = 'https://tripletex.no/v2'.freeze

  def authorize!
    response = HTTP.put("#{BASE_URL}/token/session/:create", params: { consumerToken: ENV['TRIPLETEX_CONSUMER_TOKEN'], employeeToken: ENV['TRIPLETEX_EMPLOYEE_TOKEN'], expirationDate: '2027-01-01' })
    body = response.parse
    $redis.set 'tripletex_session_token', body['value']['token']
    body['value']['token']
  end

  def authorized
    HTTP.basic_auth(user: "0", pass: session_token)
  end

  def session_token
    $redis.get('tripletex_session_token') || authorize!
  end

end
