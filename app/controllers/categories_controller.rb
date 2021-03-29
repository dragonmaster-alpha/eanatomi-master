class CategoriesController < ApplicationController

  def index
    categories = if params[:all]
      Category
    else
      Category.top.sorted
    end
    @categories = categories.active_in(context.market.key).decorate(with: CategoryGridDecorator, context: { sortable: can?(:update, Category) })
  end

  def show
    begin
      @category = Category.slug(params[:id]).decorate(context: { market_id: context.market.key })
    rescue ActiveRecord::RecordNotFound
      return not_found
    end
    @banners = @category.sorted_banners.to_a
    ensure_url(@category)
    redirect_to(category_path(@category.parent), status: 301) if @category.is_inline

    @categories = @category.regular_categories.sorted.active_in(context.market.key).decorate(with: CategoryGridDecorator, context: { sortable: can?(:update, Category) })
    @inline_categories = @category.inline_categories.sorted.active_in(context.market.key).decorate(context: { sortable: can?(:update, Category) })

    @products = @category.products.active_in(context.market.key).decorate(with: ProductGridDecorator, context: { market: context.market, sortable: (can?(:update, Product) && @category.sortable?), user: context.user })

    @enquiry = Enquiry.new(url: request.url)

    context.path.add(*@category.parents.reverse, @category)

    @cache_key = [context.market.key, @category, @categories.map(&:updated_at), @products.map(&:updated_at)].join('/')
  end

end
