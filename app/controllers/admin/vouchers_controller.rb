class Admin::VouchersController < AdminController
  before_action :set_products

  def index
    @vouchers = Voucher.all
  end

  def new
    @voucher = Voucher.new
  end

  def edit
    @voucher = Voucher.find(params[:id])
    @voucher.lines.build
  end

  def create
    @voucher = Voucher.new params[:voucher].permit!

    if @voucher.save
      redirect_to [:edit, :admin, @voucher], notice: 'Rabatkoden blev oprettet'
    else
      render 'new'
    end
  end

  def update
    @voucher = Voucher.find params[:id]

    if @voucher.update params[:voucher].permit!
      redirect_to [:edit, :admin, @voucher], notice: 'Rabatkoden blev opdateret'
    else
      render 'edit'
    end
  end

  def destroy
    Voucher.find(params[:id]).destroy
    redirect_to [:admin, :vouchers], notice: 'Rabatkoden blev slettet'
  end

  
  private

  def set_products
    @products = [['Vælg produkt', 0]] + Product.all.map do |product|
      ["#{product.name} (#{product.sku})", product.id]
    end
  end

  def authorize
    authorize! :update, Campaign
  end
  
end
