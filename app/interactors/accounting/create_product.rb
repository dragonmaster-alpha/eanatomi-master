class Accounting::CreateProduct
  include Interactor

  def call
    accounting_classes = Market.all.map(&:accounting_class).uniq
    accounting_classes.each do |accounting_class|
      accounting_product = accounting_class::Product.build(context.product)
      id = accounting_class.new.create_product(accounting_product)
      context.product.update!("#{accounting_class.to_s.demodulize.downcase}_id" => id)
    end
  end

end
