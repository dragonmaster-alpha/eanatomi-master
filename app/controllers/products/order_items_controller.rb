class Products::OrderItemsController < ApplicationController

  def create
    product = Product.slug(params[:product_id])
    order_item = add_item(product, params[:order_item][:quantity])

    addons = Product.find params[:addon_ids]&.permit!.to_h.keys
    addons.map! do |addon|
      add_item(addon, 1)
    end

    redirect_to product_order_item_path(product, order_item, addon_ids: addons.map(&:id))
  end

  def show
    @product = Product.slug(params[:product_id]).decorate(context: { market: context.market, user: context.user } )
    @current_addons = OrderItem.where(id: params[:addon_ids]).decorate
    @available_addons = ProductGridDecorator.decorate_collection(@product.object.addons, context: { market: context.market, user: context.user })
    @order_item = OrderItem.find(params[:id]).decorate
    @category = @product.main_product.category
    complementary = @product.complementaries.sorted
    @complementary = ProductGridDecorator.decorate_collection(complementary, context: { market: context.market, user: context.user })

    context.path.add(*@product.parents.reverse, @product)
  end

  private

  def add_item(product, quantity)
    vendor_price = VendorPrice.find_by(product: product, user: context.user)
    context.cart.add(product, quantity, vendor_price&.sales_price)
  end

end
