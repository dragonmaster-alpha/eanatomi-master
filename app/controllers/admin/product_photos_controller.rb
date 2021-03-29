class Admin::ProductPhotosController < AdminController
  before_action :set_product

  def index
    @photos = @product.photos.sorted
    @photo = ProductPhoto.new
  end

  def create
    ProductPhoto.create! imgix_photo: params[:product_photo][:imgix_photo], product: @product
    redirect_to [:admin, @product, :product_photos], notice: 'Billedet blev oprettet'
  end

  def destroy
    ProductPhoto.find(params[:id]).destroy!
    redirect_to [:admin, @product, :product_photos], notice: 'Billedet blev slettet'
  end

  private

    def authorize
      authorize! :update, ProductPhoto
    end

    def set_product
      @product = Product.slug(params[:product_id])
    end
end
