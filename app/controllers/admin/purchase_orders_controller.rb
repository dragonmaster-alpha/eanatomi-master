class Admin::PurchaseOrdersController < AdminController

  def index
    @manufacturers = Manufacturer.where.not(restocking_interval: nil)
    @purchase_orders = PurchaseOrder.all
  end

  def update
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.update! params[:purchase_order].permit!
    redirect_to [:admin, :purchase_orders], notice: "Bestillingen blev opdateret"
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def new
    @manufacturer = Manufacturer.find params[:manufacturer_id]
    @purchase_order = PurchaseOrder.build(@manufacturer)
  end

  private

    def authorize
      authorize! :update, PurchaseOrder
    end

end
