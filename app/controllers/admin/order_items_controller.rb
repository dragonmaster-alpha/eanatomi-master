class Admin::OrderItemsController < AdminController
  before_action :set_order
  before_action :set_order_item, only: [:edit, :update, :destroy]

  def index
    @order_items = @order.order_items
  end

  def new
    @order_item = OrderItem.new
    @products = [['Vælg produkt', 0]] + Product.all.pluck(:sku, :name_translations, :price).map do |sku, name_translations, price|
      sales_price = Currency.new(price, @order.rate, @order.vat).net_amount
      sales_price = view_context.number_to_currency(sales_price, locale: @order.market.locale)
      ["#{name_translations[ENV['DEFAULT_LOCALE']]} (#{sku}) (#{sales_price})", sku]
    end
  end

  def edit
  end

  def create
    product = Product.find_by(sku: params[:order_item][:sku_code])
    vendor_price = VendorPrice.find_by(product: product, user: @order.user)&.price

    @order_item = OrderItemFromProduct.new(product, vendor_price).order_item
    @order_item.quantity = params[:order_item][:quantity]
    @order_item.order = @order

    @order_item.save!
    redirect_to [:admin, @order, :order_items], notice: "#{@order_item} blev oprettet"
  end

  def update
    @order_item.update! params[:order_item].permit!
    redirect_to [:admin, @order, :order_items], notice: "#{@order_item} blev opdateret"
  end

  def destroy
    @order_item.destroy!
    redirect_to [:admin, @order, :order_items], notice: "#{@order_item} blev slettet"
  end

  private

    def authorize
      authorize! :update, OrderItem
    end

    def order_item_params
      params[:order_items].permit!
    end

    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def set_order
      @order = Order.find(params[:order_id])
    end

end
