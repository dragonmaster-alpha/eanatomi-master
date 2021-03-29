class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :set_relations, only: [:new, :edit, :create, :update]

  def index
    @categories = case params[:categories]
    when 'inactive'
      Category.inactive_in_markets
    else
      Category.all
    end
  end

  def new
    @category = Category.new
    @category.active_in_market = ActiveInMarket.new.activate!
    @templates = Category::TEMPLATES
    @menu_types = Category::MEGAMENU_TYPES
  end

  def edit
    @menu_types = Category::MEGAMENU_TYPES
    @templates = Category::TEMPLATES
  end

  def create
    @category = Category.create! category_params
    redirect_to @category, notice: "#{@category} blev oprettet"
  end

  def update
    @category.attributes = category_params
    TranslationChange.track! @category, current_user, :name, :body
    @category.save!
    redirect_to @category, notice: "#{@category} blev opdateret"
  end

  def destroy
    @category.destroy
    redirect_to '/', notice: "#{@category} blev slettet"
  end

  private

    def set_relations
      @categories = [['Ingen', nil]] + to_array(Category.all)
    end

    def authorize
      authorize! :update, Category
    end

    def category_params
      params[:category].permit!
    end

    def set_category
      @category = Category.slug(params[:id])
    end

    def to_array(collection)
      collection.map do |item|
        [item.option_name, item.id]
      end.sort
    end
end
