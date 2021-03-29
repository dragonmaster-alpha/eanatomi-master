class Products::Update
  include Interactor

  def call
    context.sku_was = context.product.sku

    context.product.attributes = context.attributes

    TranslationChange.track!(context.product, context.user, :name, :description)

    if context.product.save
      sync_product if sku_changed? || barcode_changed?
    else
      context.fail!
    end
  end

  private

    def sku_changed?
      context.attributes[:sku] != context.sku_was
    end

    def barcode_changed?
      context.attributes[:barcode] != context.barcode_was
    end

    def sync_product
      CreateLogisticsProductJob.perform_later(context.product)
      CreateAccountingProductJob.perform_later(context.product)
    end

end
