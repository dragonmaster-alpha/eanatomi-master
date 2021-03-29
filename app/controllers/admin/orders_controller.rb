class Admin::OrdersController < AdminController


  def index
    @statuses = %w( all placed received ready_to_pick picking_started shipped_complete cancelled pending_payment open )
    @status = params[:status] || 'all'
    @query = params[:query]

    if order = Order.number(@query)
      return redirect_to [:admin, order]
    end

    query = @query.blank? ? '*' : @query

    conditions = {}
    conditions[:status] = @status unless @status == 'all'

    @unseen_failures = Order.unseen_failures.decorate
    @needs_review = Order.needs_review.decorate

    conditions[:id] = { not: @unseen_failures.pluck(:id) + @needs_review.pluck(:id) }

    @orders = Order.search(SearchEncoder.new.encode(query), where: conditions, order: { placed_at: :desc }, page: params[:page], per_page: 20)
    @orders = OrdersDecorator.decorate(@orders)
  end

  def show
    @order = Order.find(params[:id]).decorate
    @shipping_events = @order.shipping_events
    @order_events = @order.logs
    @failures = @order.failures
    @order.failures.unseen.each &:seen!
  end

  def new
    @order = Order.new

    set_options(@order)
  end

  def edit
    @order = Order.find(params[:id])

    set_options(@order)
  end

  def create
    @order = Order.new(params[:order].permit!)
    @order.placed_at = DateTime.now
    @order.save!
    @order.set_order_number

    redirect_to [:admin, @order], notice: "#{@order} blev oprettet"
  end

  def update
    @order = Order.find(params[:id])
    @order.update! params[:order].permit!
    redirect_to [:admin, @order], notice: "#{@order} blev opdateret"
  end

  private

    def set_options(order)
      @client_types = ClientType.all

      @payment_methods = Market.all.map do |market|
        PaymentMethod.all(market.key)
      end.flatten.map(&:id).uniq

      @delivery_methods = DeliveryMethod.available_options

      @couriers = DeliveryMethod.available_couriers

      @markets = Market.all.map(&:key)
      @countries = Country.new('da').all.map do |code, country|
        [country, code.downcase]
      end
    end

    def authorize
      authorize! :update, Order
    end

end
