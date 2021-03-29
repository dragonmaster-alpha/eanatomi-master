class CreateAccountingProductJob < ApplicationJob
  queue_as :default

  def perform(product)
    Accounting::CreateProduct.call(product: product)
  end
end
