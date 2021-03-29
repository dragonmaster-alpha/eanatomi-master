class Checkout::Orders::VouchersController < ApplicationController
  def create
    @order = Order.find params[:order_id]
    @voucher = Voucher.find_by(code: params[:voucher][:code])

    if @voucher
      @order.update! voucher: @voucher
      redirect_to [:new, :checkout, :order], notice: t('.success')
    else
      flash[:alert] = t('.not_found')
      redirect_to [:new, :checkout, :order]
    end

  end
end
