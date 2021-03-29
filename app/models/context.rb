class Context

  def initialize(session_id, host, user)
    @session_id = session_id
    @host = host
    @user = user
  end

  def user
    @user || User.new
  end

  def signed_in?
    user.persisted?
  end

  def path
    @_path ||= Path.new
  end

  def cart
    @_cart ||= Cart.new(@session_id, market.key, user)
  end

  def market
    @_market ||= begin
      Market.by_domain(@host)
    end
  end

end
