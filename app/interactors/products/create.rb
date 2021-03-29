class Products::Create
  include Interactor

  def call
    context.product = Product.new(context.attributes)
    if context.product.save
      CreateLogisticsProductJob.perform_later(context.product)
      CreateAccountingProductJob.perform_later(context.product)
    else
      context.fail!
    end
  end

end
