class Orders::Duplicate
  include Interactor

  def call
    context.duplicate = context.order.deep_clone(only: fields, include: :order_items)

    context.duplicate.status = :placed
    context.duplicate.placed_at = DateTime.now
    context.duplicate.set_order_number

    context.duplicate.save!
  end

  private

    def fields
      if context.ignore_user_fields
        basic_fields
      else
        user_fields
      end
    end

    def basic_fields
      %i(
        market_id
        rate
        vat
      )
    end

    def user_fields
      filter = %w( id placed_at order_number status warehouse_id )
      fields = Order.attribute_names - filter
      fields.map(&:to_sym)
    end
end
