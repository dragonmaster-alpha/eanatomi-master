class Admin::UsersController < AdminController
  before_action :set_options

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])

    @products = [['Vælg produkt', 0]] + Product.all.pluck(:id, :sku, :name_translations, :price).map do |id, sku, name_translations, price|
      sales_price = Currency.new(price, @user.market.rate, @user.market.vat).net_amount
      sales_price = view_context.number_to_currency(sales_price, locale: @user.market.locale)
      ["#{name_translations[ENV['DEFAULT_LOCALE']]} (#{sku}) (#{sales_price})", id]
    end

    10.times do
      @user.vendor_prices.build
    end
  end

  def create
    @user = User.new params[:user].permit!
    if @user.save
      redirect_to [:edit, :admin, @user], notice: "#{@user} blev oprettet"
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to [:edit, :admin, @user], notice: "#{@user} blev opdateret"
    else
      render 'edit'
    end
  end

  private

    def authorize
      authorize! :update, User
    end

    def user_params
      params[:user].permit!
    end

    def set_options
      @markets = Market.all.map { |m| [m.country, m.key] }
      @client_types = ClientType.all
      @roles = User.roles.map { |k, v| k }
    end
end
