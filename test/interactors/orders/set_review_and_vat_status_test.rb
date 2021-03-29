require 'test_helper'

class Orders::SetReviewAndVatStatusTest < ActiveSupport::TestCase

  test 'dk invoice orders needs review' do
    order = Order.create market_id: 'dk', payment_method: 'invoice'

    Orders::SetReviewAndVatStatus.call(order: order)

    assert order.needs_review
  end

  test 'se vat_invoice orders with invalid vat needs review' do
    order = Order.create market_id: 'se', payment_method: 'vat_invoice'

    Orders::SetReviewAndVatStatus.call(order: order)

    assert order.needs_review
  end

  test 'se orders with present invalid vat needs_review' do
    order = Order.create market_id: 'se', vat_number: '123'

    Orders::SetReviewAndVatStatus.call(order: order)

    assert order.needs_review
  end

  test 'se orders with valid vat doesnt need review' do
    order = Order.create market_id: 'se', vat_number: '123'
    order.stubs(:vat_number_valid?).returns(true)

    Orders::SetReviewAndVatStatus.call(order: order)

    assert_not order.needs_review
  end

  test 'se orders without vat_number doesnt need review' do
    order = Order.create market_id: 'se'

    Orders::SetReviewAndVatStatus.call(order: order)

    assert_not order.needs_review
  end

  test 'se orders with invalid vat is not vat excempt' do
    order = Order.create market_id: 'se', vat_number: '123'

    Orders::SetReviewAndVatStatus.call(order: order)

    assert_not order.is_vat_exempt
  end

  test 'se orders with valid vat is vat excempt' do
    order = Order.create market_id: 'se', vat_number: '123'
    order.stubs(:vat_number_valid?).returns(true)

    Orders::SetReviewAndVatStatus.call(order: order)

    assert order.is_vat_exempt
  end

end
