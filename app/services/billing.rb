class Billing

  def initialize(order=nil)
    @order = order
  end

  def capture(amount=nil)
    with_retries(max_tries: 3) do
      amount ||= @order.net_amount_in_cents
      result = gateway.capture(amount, @order.payment.reference)
      if result.success?
        @order.payment.update! status: :captured, captured_amount: (amount / 100)
      else
        raise CaptureError, "Could not capture payment #{@order.payment.reference}: #{result.message}"
      end
    end
  end

  def payment_params(accepturl, capture: false, payment_method: nil, invoice: false, cancelurl: Market.first.url)
    params = default_params
    params[:instantcapture] = 1 if capture
    params[:invoice] = invoice_params.to_json if invoice
    params[:accepturl] = accepturl
    params[:callbackurl] = accepturl
    params[:cancelurl] = cancelurl
    params[:paymentcollection] = payment_method_id(payment_method) if payment_method
    params[:lockpaymentcollection] = 1
    params[:hash] = digest(params)
    params
  end

  def payment_link(accepturl, capture: false, invoice: false, cancelurl: nil, payment_method: nil)
    params = payment_params(accepturl, capture: capture, payment_method: nil, invoice: invoice, cancelurl: cancelurl).map do |k, v|
      "#{k}=#{v}"
    end.join('&')

    "https://ssl.ditonlinebetalingssystem.dk/integration/ewindow/Default.aspx?#{params}"
  end

  def self.currency(code)
    {
      '208' => 'dkk',
      '752' => 'sek',
      '578' => 'nok',
      '978' => 'eur'
    }.fetch(code.to_s)
  end

  private

    def payment_method_id(payment_method)
      {
        'credit_card' => 1,
        'mobilepay' => 4,
        'klarna' => 0,
      }.fetch(payment_method.to_s)
    end

    def default_params
      {
        merchantnumber: merchant_number,
        orderid: @order.order_number,
        currency: currency_code(@order.market.currency),
        language: language_code(@order.market.locale),
        amount: @order.net_amount_in_cents,
        paymentcollection: payment_collection,
        lockpaymentcollection: 1,
        ownreceipt: 1,
        splitpayment: 1,
        windowstate: 3,
      }
    end

    def invoice_params
      customer_names = @order.name.split(' ')
      shipping_names = @order.delivery_name.split(' ')

      {
        customer: {
          emailaddress: @order.email,
          firstname: customer_names[0],
          lastname: customer_names[1, 3]&.join(' '),
          attention: @order.att,
          address: @order.address,
          zip: @order.zip_code,
          city: @order.city,
          country: @order.country,
          phone: @order.phone
        },
        shippingaddress: {
          firstname: shipping_names[0],
          lastname: shipping_names[1, 3]&.join(' '),
          attention: @order.delivery_att,
          zip: @order.zip_code,
          city: @order.city,
          country: @order.country,
          phone: @order.phone
        },
        lines: order_items

      }
    end

    def order_items
      items = @order.order_items.map do |item|
        {
          id: item.sku_code,
          description: item.name,
          price: (item.gross_price * 100).to_i,
          quantity: item.quantity,
          vat: (@order.vat * 100).to_i
        }
      end

      items << delivery_fee
      items << clearance_fee if @order.clearance_fee?
      items << gift_card if @order.gift_card?
      items
    end

    def gift_card
      description = I18n.t('activerecord.attributes.order.gift_card', locale: @order.market.locale)
      {
        id: @order.market.gift_card_sku,
        description: description,
        price: -(@order.gift_card_gross_amount * 100).to_i,
        quantity: 1,
        vat: (@order.vat * 100).to_i
      }
    end

    def delivery_fee
      description = I18n.t('activerecord.attributes.order.delivery_fee', locale: @order.market.locale)
      {
        id: @order.market.delivery_sku,
        description: description,
        price: (@order.delivery_gross_amount * 100).to_i,
        quantity: 1,
        vat: (@order.vat * 100).to_i
      }
    end

    def clearance_fee
      description = I18n.t('activerecord.attributes.order.clearance_fee', locale: @order.market.locale)
      {
        id: @order.market.clearance_sku,
        description: description,
        price: (@order.clearance_gross_amount * 100).to_i,
        quantity: 1,
        vat: (@order.vat * 100).to_i
      }
    end

    def payment_collection
      {
        'credit_card' => 1,
        'mobilepay' => 4,
        'klarna' => 3
      }.fetch(@order.payment_method.to_s)
    end

    def currency_code(currency)
      {
        'dkk' => 208,
        'sek' => 752,
        'nok' => 578,
        'eur' => 978
      }.fetch(currency)
    end

    def language_code(locale)
      {
        'da' => 1,
        'sv' => 3,
        'nb' => 4
      }.fetch(locale, 1)
    end

    def digest(params)
      key = @order.market.epay_md5_key

      md5 = Digest::MD5.new

      md5 << params.values.join
      md5 << key

      md5.hexdigest
    end

    def merchant_number
      @order.market.epay_merchant_number
    end

    def gateway
      @_gateway = ActiveMerchant::Billing::EpayGateway.new(
        login: merchant_number
      )
    end

    class CaptureError < StandardError
    end


end
