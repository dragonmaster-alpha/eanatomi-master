class Admin::CategoryMegaimagesController < AdminController
  before_action :set_category

  def index
    @mega_images = @category.mega_images.sorted
    @mega_image = CategoryMegaimage.new
  end

  def new
    @types = CategoryMegaimage::MEGA_TYPES
    @mega_image = CategoryMegaimage.new
  end

  def create
    CategoryMegaimage.create! imgix_photo: params[:category_megaimage][:imgix_photo],
      url: params[:category_megaimage][:url],
      mega_type: params[:category_megaimage][:mega_type],
      category: @category
    redirect_to [:admin, @category, :category_megaimages], notice: 'Billedet blev oprettet'
  end

  def destroy
    CategoryMegaimage.find(params[:id]).destroy!
    redirect_to [:admin, @category, :category_megaimages], notice: 'Billedet blev slettet'
  end

  private

  def authorize
    authorize! :update, CategoryMegaimage
  end
  
  def set_category
    @category = Category.slug(params[:category_id])
  end
end
