class Checkout::Orders::AcceptanceController < ApplicationController

  def create
    @order = Order.find(params[:order_id])

    return redirect_to new_checkout_order_path, notice: 'Du har ingen varer i kurven' if @order.order_items.empty?
    return respond_ok unless @order.open?

    @order.update! order_params
    @order.set_order_number

    if use_epay?
      accepturl = checkout_order_payments_url(@order)
      cancelurl = new_checkout_order_url
      redirect_to Billing.new(@order).payment_link(accepturl, invoice: true, cancelurl: cancelurl, payment_method: @order.payment_method)
    else
      ::Orders::SetReviewAndVatStatus.call(order: @order)
      ::Orders::SetInStockCache.call(order: @order)
      ::Orders::Place.call(order: @order)
      redirect_to [:checkout, @order]
    end
  end

  private

  def respond_ok
    redirect_to [:checkout, @order]
  end

    def use_epay?
      @order.payment_method == 'credit_card' || @order.payment_method == 'klarna' || @order.payment_method == 'mobilepay'
    end

    def order_params
      params[:order].permit(
        :client_type,

        :email,
        :name,
        :address,
        :zip_and_city,
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
        :delivery_zip_and_city,
        :delivery_zip_code,
        :delivery_city,
        :flex_instructions,

        :payment_method,

        :is_subscribing,

        :courier
      )
    end

end
