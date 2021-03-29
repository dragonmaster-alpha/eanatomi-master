class Accounting::Economic::Client

  def initialize(raise_errors=true)
    @raise_errors = raise_errors
  end

  def post(action, body, params={})
    call do
      path = endpoint(action, params)
      response = ApiLog.log_request('economic', 'POST', path, request_body: body) { http_client.post(path, json: body) }
      parse_response(response)
    end
  end

  def put(action, body, params={})
    call do
      path = endpoint(action, params)
      response = ApiLog.log_request('economic', 'PUT', path, request_body: body) { http_client.put(path, json: body) }
      parse_response(response)
    end
  end

  def get(action, params={})
    call do
      path = endpoint(action, params)
      response = ApiLog.log_request('economic', 'GET', path) { http_client.get(path) }
      parse_response(response)
    end
  end

  def delete(action, params={})
    call do
      path = endpoint(action, params)
      response = ApiLog.log_request('economic', 'DELETE', path) { http_client.delete(path) }
      parse_response(response)
    end
  end

  def get_raw(action, params={})
    call do
      http_client.get(endpoint(action, params))
    end
  end

  private

    def call
      with_retries(max_tries: 3) { yield }
    end

    def parse_response(response)
      json = JSON.parse(response)
      success = response.code.to_s =~ /\A2/ ? true : false

      Rails.logger.debug json
      raise Accounting::OperationError, json['message'] if !success && @raise_errors

      Accounting::Economic::Response.new(success, json)
    end

    def action_from_params(action, params)
      params.each do |k, v|
        action.gsub! ":#{k}", v.to_s
      end
      action
    end


    def grant_token
      ENV["ECONOMIC_GRANT_TOKEN"]
    end

    def http_client
      Http.headers('X-AppSecretToken' => ENV['ECONOMIC_SECRET_TOKEN'], 'X-AgreementGrantToken' => grant_token)
    end

    def endpoint(action, params={})
      action = action_from_params(action, params)
      # return 'https://hookb.in/Ew9qxod2'
      "https://restapi.e-conomic.com/#{action}"
    end

end
