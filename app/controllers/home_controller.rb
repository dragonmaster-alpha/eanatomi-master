class HomeController < ApplicationController

  def index
    @page = Page.home_page.decorate
    @full_campaigns = Campaign.active_in(context.market.key).in_home_full
    @half_campaigns = Campaign.active_in(context.market.key).in_home_half
    featured = FeaturedCategory.active_in(context.market.key).sorted.map(&:category)
    featured_products = FeaturedProduct.active_in(context.market.key).sorted.map(&:product)
    @categories = CategoryGridDecorator.decorate_collection(featured, context: { user: context.user })
    @products = ProductGridDecorator.decorate_collection(featured_products, context: { market: context.market, user: context.user })
  end

end
