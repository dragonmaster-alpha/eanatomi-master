class Admin::Products::DuplicatesController < AdminController

  def create
    @sku = params[:product][:sku]
    @product = Product.slug(params[:product_id])
    duplicate = Products::Duplicate.call(product: @product, sku: @sku)

    if duplicate.success?
      redirect_to [:edit, :admin, duplicate.duplicate]
    else
      flash[:alert] = duplicate.error
      redirect_back fallback_location: root_path
    end

  end


  private

  def authorize
    authorize! :update, Product
  end

end
