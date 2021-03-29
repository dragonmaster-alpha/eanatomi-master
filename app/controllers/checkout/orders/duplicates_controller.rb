class Checkout::Orders::DuplicatesController < ApplicationController

  def show
    context.cart.order.destroy
    template = Order.find(params[:order_id])
    @order = Orders::Duplicate.call(order: template, ignore_user_fields: true).duplicate


    session[:init] = true unless session[:loaded]
    @order.update! status: :open, session_id: session.id

    redirect_to [:new, :checkout, :order]
  end

  def create
    @order = Order.find(params[:order_id])
    duplicate = Orders::Duplicate.call(order: @order).duplicate
    duplicate.template!

    OrderMailer.share(recipient: params[:share][:recipient], message: params[:share][:message], order: duplicate, sender: params[:share][:sender]).deliver_later
    OrderMailer.share_confirmation(recipient: params[:share][:recipient], message: params[:share][:message], order: duplicate, sender: params[:share][:sender]).deliver_later if params[:share][:sender].present?

    redirect_to [:new, :checkout, :order], notice: t('.success')
  end

end
