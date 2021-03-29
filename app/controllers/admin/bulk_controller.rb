class Admin::BulkController < AdminController

  BULK_FIELDS = %i( id sku name_da name_sv name_nb price cost_price
                    offer_price barcode supplier_id stock restocking_amount restocking_threshold
                    size label_da label_sv label_nb active_status
                    category_id shipping_time_id ).freeze

  def show
    @categories = Category.where('products_count > 0').map do |category|
      [category.path.reverse.join(' - '), category.id]
    end

    @manufacturers = Manufacturer.all.map { |m| [m, m.id] }

    @categories.insert(0, ['Alle kategorier', nil])
    @manufacturers.insert(0, ['Alle producenter', nil])
  end

  def create
    products = Product.where(export_params)
    export = Export.new(products, BULK_FIELDS)

    send_data export.raw, filename: 'products.xls'
  end

  def update
    storage = Storage.create! file: params[:import][:file]
    ImportProductsJob.perform_later(storage)

    redirect_to [:admin, :bulk], notice: 'Filen er lagt i kø til at importere'
  end

  private

    def authorize
      authorize! :update, Import
    end

    def export_params
      params[:export].permit!.delete_if { |k, v| v.blank? }
    end

end
