class Checkout::OrderItemsController < ApplicationController

  def update
    item = OrderItem.find(params[:id])
    item.update params[:order_item].permit(:quantity)

    return redirect_to new_checkout_order_path if context.cart.empty?

    render json: {
      order_html: render_to_string(partial: 'checkout/orders/order', locals: { order: context.cart.order.decorate }),
      to_pay_html: render_to_string(partial: 'checkout/orders/to_pay', locals: { order: context.cart.order.decorate })
    }
  end

  def destroy
    OrderItem.find(params[:id]).destroy

    return redirect_to new_checkout_order_path if context.cart.empty? 

    render json: {
      order_html: render_to_string(partial: 'checkout/orders/order', locals: { order: context.cart.order.decorate }),
      to_pay_html: render_to_string(partial: 'checkout/orders/to_pay', locals: { order: context.cart.order.decorate })
    }
  end

end
