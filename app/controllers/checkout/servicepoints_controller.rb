class Checkout::ServicepointsController < ApplicationController

  def show
    courier = params[:courier].presence || context.cart.order.courier
    market = params[:market].present? ? Market.fetch(params[:market]) : context.market

    @servicepoints = if params[:query].length > 3
      case courier
      when 'postnord'
        Postnord::Servicepoint.find(zip_code: zip_code(params[:query]), limit: 5, street: street(params[:query]), country_code: market.country_code, locale: context.market.locale)
      when 'gls'
        GLS::Servicepoint.find(zip_code: zip_code(params[:query]), limit: 5, street: street(params[:query]), country_code: market.country_code)
      end
    end

    @servicepoints ||= []

    render layout: false
  end

  private

  def zip_code(query)
    match = /(\d+)(.*)/.match(query)
    match[1] if match
  end

  def street(query)
    match = /(\d+)(.*)/.match(query)
    match[2] if match
  end

end
