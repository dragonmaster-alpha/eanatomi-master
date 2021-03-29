class SearchController < ApplicationController
  def index
    @query = params[:query].to_s.downcase

    if product = Product.active_in(context.market.key).sku(@query)
      redirect_to(product)
    end

    @results = ProductSearch.new(context: context, query: @query).call
    @enquiry = Enquiry.new(url: request.url)
    @products = ProductGridDecorator.decorate_collection(@results, context: { market: context.market, user: context.user })
  end
end
