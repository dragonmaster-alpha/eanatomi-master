class Admin::PagesController < AdminController
  before_action :set_page, only: [:edit, :update, :destroy]
  before_action :set_pages

  def index
    @pages = Page.sorted
  end

  def new
    @page = Page.new
    @page.active_in_market = ActiveInMarket.new.activate!
    @placements = Page::PLACEMENTS
  end

  def edit
    @placements = Page::PLACEMENTS
  end

  def create
    @page = Page.create! page_params
    redirect_to @page, notice: "#{@page} blev oprettet"
  end

  def update
    @page.attributes = page_params
    TranslationChange.track! @page, current_user, :name, :body
    @page.save!
    redirect_to @page, notice: "#{@page} blev opdateret"
  end

  def destroy
    @page.destroy
    redirect_to '/', notice: "#{@page} blev slettet"
  end

  private

    def authorize
      authorize! :update, Page
    end

    def page_params
      params[:page].permit!
    end

    def set_page
      @page = Page.slug(params[:id])
    end

    def set_pages
      @pages = [nil] + Page.root.sorted.pluck(:id, :name_translations).map { |id, name_translations| [name_translations[ENV['DEFAULT_LOCALE']], id] }
    end
end
