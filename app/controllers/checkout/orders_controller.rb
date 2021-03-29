class Checkout::OrdersController < ApplicationController

  def new
    return render 'empty' if context.cart.empty? && !params[:preview] && !hotjar?

    @order = context.cart.order.decorate
    @client_types = ClientType.all
    @delivery_methods = DeliveryMethod.for_market(context.market.key)
    platform = is_mobile? ? :mobile : :desktop
    @payment_methods = PaymentMethod.all(context.market.key, platform: platform)
    @terms_page = Page.terms_page
  end

  def update
    @order = Order.find(params[:id])
    @order.update!(order_params)

    render json: {
      order_html: render_to_string(partial: 'checkout/orders/order', locals: { order: @order.decorate }),
      to_pay_html: render_to_string(partial: 'checkout/orders/to_pay', locals: { order: @order.decorate }),
    }
  end

  def show
    @order = Order.find(params[:id]).decorate
    # @order_new = Order.find(params[:id]).decorate
    @test = 'test'
  end

  private

    def order_params
      params[:order].permit(
        :client_type,

        :email,
        :name,
        :address,
        :zip_code,
        :city,
        :phone,
        :att,
        :reference_number,
        :vat_number,
        :ean_number,

        :delivery_method,

        :servicepoint_id,
        :servicepoint_name,
        :servicepoint_street,
        :servicepoint_zip_code,
        :servicepoint_city,
        :servicepoint_country_code,

        :delivery_name,
        :delivery_att,
        :delivery_address,
        :delivery_zip_code,
        :delivery_city,
        :flex_instructions,

        :payment_method,

        :is_subscribing,

        :courier
      )
    end



end
