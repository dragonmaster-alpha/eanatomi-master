class Admin::CategoryBannersController < AdminController
  before_action :set_category
  def index
    @banners = @category.banners.sorted
    @banner = CategoryBanner.new
  end

  def create
    CategoryBanner.create! imgix_photo: params[:category_banner][:imgix_photo], category: @category
    redirect_to [:admin, @category, :category_banners], notice: 'Billedet blev oprettet'
  end

  def destroy
    CategoryBanner.find(params[:id]).destroy!
    redirect_to [:admin, @category, :category_banners], notice: 'Billedet blev slettet'
  end

  private
    def authorize
      authorize! :update, CategoryBanner
    end

    def set_category
      @category = Category.slug(params[:category_id])
    end
end
