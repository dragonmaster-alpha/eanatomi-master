class SubscriptionsController < ApplicationController

  def create
    Subscription.new(params[:subscription][:email], context.market.key, name: params[:subscription][:name]).subscribe
    redirect_back fallback_location: root_path, notice: t('.subscribed_text')
  end

end
