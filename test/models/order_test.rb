require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test "droppoint with none selected" do
    order = CustomerOrderFromOrder.new(Order.new(
      delivery_method: 'droppoint',
      name: 'invoice name'
    )).customer_order

    assert_equal 'invoice name', order.order_invoice_information.delivery_name
    assert_equal 'nearest', order.order_invoice_information.shipping_form
  end

  test "droppoint with selected servicepoint" do
    order = CustomerOrderFromOrder.new(Order.new(
      delivery_method: 'droppoint',
      name: 'invoice name',
      servicepoint_id: 'servicepoint id'
    )).customer_order

    assert_equal 'invoice name', order.order_invoice_information.delivery_name
    assert_equal 'servicepoint id', order.order_invoice_information.delivery_place_id
    assert_equal 'servicepoint', order.order_invoice_information.shipping_form
  end

  test "droppoint with alternative address" do
    order = CustomerOrderFromOrder.new(Order.new(
      delivery_method: 'droppoint',
      name: 'invoice name',
      delivery_name: 'delivery name'
    )).customer_order

    assert_equal 'delivery name', order.order_invoice_information.delivery_name
    assert_equal 'nearest', order.order_invoice_information.shipping_form
  end

  test "door" do
    order = CustomerOrderFromOrder.new(Order.new(
      delivery_method: 'door',
      name: 'invoice name',
      delivery_name: 'delivery name'
    )).customer_order

    assert_equal 'delivery name', order.order_invoice_information.delivery_name
  end

  test "flex delivery" do
    order = CustomerOrderFromOrder.new(Order.new(
      delivery_method: 'door',
      flex_instructions: 'doorstep'
    )).customer_order

    assert_equal 'doorstep', order.order_invoice_information.delivery_instructions
    assert_equal 'flex', order.order_invoice_information.shipping_form
  end

end
