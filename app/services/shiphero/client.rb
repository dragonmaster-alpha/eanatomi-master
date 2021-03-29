class Shiphero::Client

  def get(path)
    path = url(path)
    ApiLog.log_request('shiphero', 'GET', path) do
      http.get(path)
    end
  end

  def post(path, params)
    path = url(path)
    params[:token] = Shiphero.api_key
    ApiLog.log_request('shiphero', 'POST', path, request_body: params) do
      http.post(path, json: params)
    end
  end

  private

  def url(path)
    "https://api-gateway.shiphero.com/#{path}"
  end

  def http
    Http.headers(accept: 'application/json', 'x-api-key' => Shiphero.api_key)
  end

end
