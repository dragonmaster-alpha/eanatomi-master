class SearchPreviewsController < ApplicationController
  def index
    @query = params[:query].to_s.downcase
    result = ProductSearch.new(context: context, query: @query, limit: 5).call
    @products = ProductDecorator.decorate_collection(result, context: { market: context.market, user: context.user })
    @categories = Category.
      active_in(context.market.key).
      decorate(with: CategoryDecorator).
      select { |category| category.name.downcase.include?(@query) }

    render layout: false
  end
end
