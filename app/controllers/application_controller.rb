class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: ENV['HTTP_BASIC_AUTH_NAME'], password: ENV['HTTP_BASIC_AUTH_PASSWORD'] if ENV['HTTP_BASIC_AUTH_NAME'].present? && ENV['HTTP_BASIC_AUTH_PASSWORD'].present?
  before_action :set_locale_and_timezone, :set_gon
  helper_method :show_search?, :current_path, :show_market_notice?, :shipping_today?, :suggested_market

  rescue_from AccessGranted::AccessDenied do |exception|
    redirect_to root_path, alert: 'You don\'t have permission to access this page.'
  end


  def not_found
    respond_to do |format|
      format.html { render 'not_found', status: :not_found }
      format.any { head :not_found }
    end
  end

  private

  def suggested_market
    if params[:suggest_market] == 'no'
      session[:suggest_market] = false
    end

    return if session[:suggest_market] == false


    @_suggested_market ||= begin
      preferred_lang = request.headers['Accept-Language'].to_s.split(',').first

      if context.market.locale != preferred_lang
        Market.find_by(locale: preferred_lang)
      end
    end
  end

    def show_search?
      true
    end

    def shipping_today?
      time = Time.zone.now
      time.on_weekday? && time.hour < 12
    end

    def require_admin!
      raise AccessGranted::AccessDenied unless current_user&.admin?
    end

    def  show_market_notice?
      return false if cookies[:hide_market_notice]
      context.market.notice?
    end

    def hotjar?
      request.headers['HTTP_USER_AGENT'].to_s.include? 'Hotjar'
    end

    def is_mobile?
      user_agents = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                          'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                          'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                          'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
                          'mobile|zune'

      request.user_agent.to_s.downcase =~ Regexp.new(user_agents)
    end


    def current_path
      request.path
    end

    def ensure_url(item)
      if params[:id] != item.to_param
        redirect_to item, status: 301
      end
    end

    def current_policy
      @current_policy ||= ::AccessPolicy.new(context.user)
    end

    def set_gon
      gon.push({
        controller_name: controller_path.gsub('/', '_')
      })
    end

    def set_locale_and_timezone
      I18n.locale = context.market.locale
      Time.zone = context.market.timezone
    end

    def context
      @_context ||= Context.new(session.id, request.host, current_user)
    end
end
