class Admin::ProductsController < AdminController
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :set_relations, only: [:new, :edit, :create, :update]

  def index
    if @query = params[:query].presence
      @products = Product.search SearchEncoder.new.encode(@query), page: params[:page], per_page: 100
    else
      @products = case params[:products]
      when 'inactive'
        Product.inactive_in_markets
      when 'missing_sv'
        missing_products('sv')
      when 'missing_nb'
        missing_products('nb')
      when 'missing_fi'
        missing_products('fi')
      else
        Product.all
      end.order(created_at: :desc).page(params[:page]).per(100)
    end
  end

  def destroy_datasheet
    Product.slug(params[:product_id]).update datasheet: nil
    head :ok
  end

  def new
    @product = Product.new(active_in_market: ActiveInMarket.new.activate!)
    build_volume_prices
    build_descriptions
  end

  def edit
    build_volume_prices
    build_descriptions
  end

  def create
    create_product = Products::Create.call(attributes: product_params)
    @product = create_product.product

    if create_product.success?
      redirect_to @product, notice: "#{@product} blev oprettet"
    else
      render 'new'
    end
  end

  def update
    create_product = Products::Update.call(product: @product, attributes: product_params, user: current_user)
    @product = create_product.product

    if create_product.success?
      redirect_to @product, notice: "#{@product} blev opdateret"
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to '/', notice: "#{@product} blev slettet"
  end

  private

    def missing_products(locale)
      Product.active_in(context.market.key).where("name_translations -> '#{locale}' IN (NULL, '', name_translations -> 'da')").or(
        Product.active_in(context.market.key).where("description_translations -> '#{locale}' IN (NULL, '', description_translations -> 'da')")).or(
          Product.active_in(context.market.key).where("name_translations ? '#{locale}' = false"))
    end

    def authorize
      authorize! :update, Product
    end

    def product_params
      if context.user.admin?
        Humanizer::Sanitize.params(params[:product].permit!, 'complementary_ids' => :array, 'addon_ids' => :array, 'component_ids' => :array)
      else
        Humanizer::Sanitize.params(params[:product].permit!, {})
      end
    end

    def set_relations
      @categories = to_array(Category.all).insert(0, ['-', nil])
      @products = to_array(Product.where.not(id: params[:id]).not_variant).insert(0, ['-', nil])
      @manufacturers = to_array(Manufacturer.all)
      @shipping_times = to_array(ShippingTime.all)

      gon.products = Product.active_in(context.market.key).all.map do |product|
        { id: product.id, name: product.name_da, sku: product.sku }
      end
    end

    def set_product
      @product = Product.slug params[:id]
    end

    def build_volume_prices
      3.times do
        @product.volume_prices.build
      end
    end

    def build_descriptions
      3.times do
        @product.additional_descriptions.build
      end
    end

    def to_array(collection)
      collection.map do |item|
        [item.option_name, item.id]
      end.sort_by { |name, id| name.to_s }
    end

end
