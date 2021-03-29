class Admin::PageBannersController < AdminController
  before_action :set_page
  def index
    @banners = @page.banners.sorted
    @banner = PageBanner.new
  end

  def create
    PageBanner.create! imgix_photo: params[:page_banner][:imgix_photo], page: @page
    redirect_to [:admin, @page, :page_banners], notice: 'Billedet blev oprettet'
  end

  def destroy
    PageBanner.find(params[:id]).destroy!
    redirect_to [:admin, @page, :page_banners], notice: 'Billedet blev slettet'
  end

  private
  def authorize
    authorize! :update, PageBanner
  end

  def set_page
    @page = Page.slug(params[:page_id])
  end
end
