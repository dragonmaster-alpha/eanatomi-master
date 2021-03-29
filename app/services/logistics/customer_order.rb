class Logistics::CustomerOrder
  attr_accessor :order_number, :order_lines, :order_invoice_information

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def order_lines
    @order_lines ||= []
  end

  def serialize
    {
      'order:AuthenticationID'        => Logistics.token,
      'order:orderInvoiceInformation' => order_invoice_information.serialize,
      'order:orderLines'              => { 'order:CustomerOrder.OrderLine' => order_lines.map(&:serialize) },
      'order:orderNumber'             => order_number
    }
  end

end
