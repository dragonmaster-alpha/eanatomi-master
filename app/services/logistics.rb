class Logistics


  def send_order(order)
    call do
      response = customer_client.call(:send_customer_order, message: { 'tns:co' => order.serialize })
      response.body
    end
  end

  def get_order_status(placed_after)
    call do
      response = customer_client.call(:get_order_statuses, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:AfterDate' => placed_after.to_datetime })
      statuses = response.body[:get_order_statuses_response][:get_order_statuses_result][:order_status] || []

      statuses = [statuses] if statuses.is_a?(Hash)

      statuses.map do |status|
        status[:status] = order_status(status[:order_status_id])
        status
      end
    end
  end

  def cancel_order(order_number)
    call do
      customer_client.call(:send_order_cancellations, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:orderCancellations' => [
        { 'order:OrderCancellation' => { 'order:orderNumber' => order_number } }
      ]})
    end
  end

  def get_tracking_codes(placed_after)
    call do
      response = customer_client.call(:get_tt_codes, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:AfterDate' => placed_after.to_datetime })
      codes = response.body[:get_tt_codes_response][:get_tt_codes_result][:tt_code] || []
      codes = [codes] if codes.is_a?(Hash)

      codes
    end
  end

  def get_tracking_code(order_number)
    call do
      response = customer_client.call(:get_order_tracking_codes, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:OrderNumber' => order_number })
      codes = response.body[:get_order_tracking_codes_response][:get_order_tracking_codes_result][:order_tracking_code] || []
      codes = [codes] if codes.is_a?(Hash)

      codes.map { |c| c[:code] }
    end
  end

  def get_stock(ean_numbers)
    call do
      ean_numbers = Array(ean_numbers)
      response = inventory_client.call(:get_stock, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:EANs' => {'array:string' => ean_numbers } })
      stocks = response.body[:get_stock_response][:get_stock_result][:stock] || []
      stocks = [stocks] if stocks.is_a?(Hash)
      stocks
    end
  end

  def send_products(products)
    call do
      response = inventory_client.call(:send_products, message: { 'tns:AuthenticationID' => Logistics.token, 'tns:p' => products.map(&:serialize) })
      response.body
    end
  end

  def self.token
    ENV['E_LOGISTICS_TOKEN']
  end

  private

    def call
      with_retries(max_tries: 3) { yield }
    end

    def order_status(code)
      {
        '1' => :received,
        '2' => :ready_to_pick,
        '3' => :picking_started,
        '4' => :shipped_complete,
        '5' => :shipped_incomplete,
        '6' => :cancelled,
        '7' => :waiting
      }[code.to_s]
    end

    def fix_timezone(date)
      date.to_s.gsub('+00:00', '+02:00').to_datetime
    end

    def endpoint
      ENV['E_LOGISTICS_ENDPOINT'] || 'test.dansk-e-logistik.dk'
    end

    def inventory_client
      @inventory_client ||= Savon.client(
        wsdl: "http://#{endpoint}/V1/InventoryService/InventoryService_V1_1.svc?wsdl",
        logger: Rails.logger,
        log_level: :debug,
        log: true,
        namespaces: {
          'xmlns:array' => 'http://schemas.microsoft.com/2003/10/Serialization/Arrays',
          'xmlns:product' => 'http://schemas.datacontract.org/2004/07/InventoryService_V1_1'
        }
      )
    end

    def customer_client
      @customer_client ||= Savon.client(
        wsdl: "http://#{endpoint}/V1/CustomerOrderService/CustomerOrderService_V1_2.svc?wsdl",
        logger: Rails.logger,
        log_level: :debug,
        log: true,
        namespaces: {
          'xmlns:order' => 'http://schemas.datacontract.org/2004/07/CustomerOrderService_V1_2'
        }
      )
    end

end
