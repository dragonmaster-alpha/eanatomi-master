class Orders::SetReviewAndVatStatus
  include Interactor

  def call
    set_review_status
    set_vat_exempt
  end

  private

  def set_review_status
    if payed_with_invoice? || payed_with_vat_invoice_and_vat_invalid? || is_abroad_and_vat_number_invalid?
      context.order.update! needs_review: true
    end
  end

  def set_vat_exempt
    if is_abroad_and_vat_number_valid?
      context.order.update! is_vat_exempt: true
    end
  end

  def payed_with_vat_invoice_and_vat_invalid?
    context.order.payment_method == 'vat_invoice' && context.order.market_id == 'se' && !context.order.vat_number_valid?
  end

  def is_abroad_and_vat_number_invalid?
    context.order.vat_number.present? && context.order.market_id == 'se' && !context.order.vat_number_valid?
  end

  def is_abroad_and_vat_number_valid?
    context.order.vat_number.present? && context.order.market_id == 'se' && context.order.vat_number_valid?
  end

  def payed_with_invoice?
    context.order.payment_method == 'invoice'
  end

end
