class Shiphero::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def inventory_update
    data = JSON.parse(request.raw_post)
    product = Product.find_by(sku: data['inventory'].first['sku'])
    product.update! stock: data['inventory'].first['inventory']

    respond_ok
  end

  def shipment_update
    if order = Order.number(params[:fulfillment][:order_number])
      ShippingEvent.create(order: order, status: :shipped_complete, occurred_at: DateTime.now)
      order.update_status!
      Shipment.find_or_create_by(order: order, code: params[:fulfillment][:tracking_number], distributor: params[:fulfillment][:shipping_carrier])
      OrderShippedJob.perform_later(order)
    end

    respond_ok
  end

  def order_canceled
    if order = Order.number(params[:order_number])
      order.cancelled!
      order.log!('Order cancelled')
    end

    respond_ok
  end

  private

  def respond_ok
    render json: {
      "code": "200",
      "Message": "Success"
    }
  end
end
