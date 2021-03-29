class Admin::FeaturedProductsController < AdminController

  def index
    @featured_products = FeaturedProduct.all
  end

  def new
    @featured_product = FeaturedProduct.new
    @featured_product.active_in_market = ActiveInMarket.new.activate!
    @products = ['Vælg produkt', nil] + Product.all.map do |product|
      ["#{product.name} (#{product.sku})", product.id]
    end
  end

  def edit
    @featured_product = FeaturedProduct.find(params[:id])
    @products = ['Vælg produkt', nil] + Product.all.map do |product|
      ["#{product.name} (#{product.sku})", product.id]
    end
  end

  def create
    @featured_product = FeaturedProduct.new params[:featured_product].permit!
    @featured_product.save!
    redirect_to [:admin, :featured_products], notice: "#{@featured_product} blev oprettet"
  end

  def update
    @featured_product = FeaturedProduct.find(params[:id])
    @featured_product.update! params[:featured_product].permit!
    redirect_to [:admin, :featured_products], notice: "#{@featured_product} blev opdateret"
  end

  def destroy
    @featured_product = FeaturedProduct.find(params[:id])
    @featured_product.destroy!
    redirect_to [:admin, :featured_products], notice: "#{@featured_product} blev slettet"
  end

  private

    def authorize
      authorize! :update, FeaturedProduct
    end

end
