class ProductsController < ApplicationController

  def show
    begin
      @product = Product.slug(params[:id]).decorate(context: { market: context.market, user: context.user } )
    rescue ActiveRecord::RecordNotFound
      return not_found
    end

    return not_found if !@product.active_in_market?(context.market.key) && !context.user.admin?

    return redirect_to @product.main_product if @product.is_variant?

    ensure_url(@product)

    @order_item = OrderItem.new(quantity: 1)
    @category = @product.category

    @product_schema = ProductSchema.new(@product, context.market, url: product_url(@product))


    similar = @category.products.active_in(context.market.key).where.not(id: @product.id).sorted
    @similar = ProductGridDecorator.decorate_collection(similar, context: { market: context.market, user: context.user })

    @shipping_price = DeliveryMethod.default(context.market.key).cost
    # @product_photo = @product.photo
    #
    # @product_photos = @product.photos.to_a
    # @product_photos.delete(@product_photo)

    context.path.add(*@product.parents.reverse.reject(&:is_inline), @product)

    gon.push({
      product: {
        sku: @product.sku,
        price: Currency.new(@product.sales_price, context.market.rate, context.market.vat).net_amount
      }
    })
  end

end
