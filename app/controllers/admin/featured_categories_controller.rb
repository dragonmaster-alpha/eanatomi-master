class Admin::FeaturedCategoriesController < AdminController
  def index
    @featured_categories = FeaturedCategory.all
  end

  def new
    @featured_category = FeaturedCategory.new
    @featured_category.active_in_market = ActiveInMarket.new.activate!
    @categories = ['Vælg kategori', nil] + Category.all.map do |category|
      [category.name, category.id]
    end
  end

  def edit
    @featured_category = FeaturedCategory.find(params[:id])
    @categories = ['Vælg kategori', nil] + Category.all.map do |category|
      [category.name, category.id]
    end
  end

  def create
    @featured_category = FeaturedCategory.new params[:featured_category].permit!
    @featured_category.save!
    redirect_to [:admin, :featured_categories], notice: "#{@featured_category} blev oprettet"
  end

  def update
    @featured_category = FeaturedCategory.find(params[:id])
    @featured_category.update! params[:featured_category].permit!
    redirect_to [:admin, :featured_categories], notice: "#{@featured_category} blev opdateret"
  end

  def destroy
    @featured_category = FeaturedCategory.find(params[:id])
    @featured_category.destroy!
    redirect_to [:admin, :featured_categories], notice: "#{@featured_category} blev slettet"
  end

  private

    def authorize
      authorize! :update, FeaturedCategory
    end

end
