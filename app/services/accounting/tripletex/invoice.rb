class Accounting::Tripletex::Invoice < Accounting::Base::Invoice

  # BANK
  # KORT

  def save!
    result = Accounting::Tripletex::Client.new.post("order", self.serialize)
    @id = result['value']['id']
    self
  end

  def book!
    result = Accounting::Tripletex::Client.new.put("order/#{@id}/:invoice?invoiceDate=#{invoice_date}&sendToCustomer=false&paymentTypeId=#{payment_type_id}&paidAmount=#{paid_amount}", {})
    @id = result['value']['id']
    self
  end

  def invoice_pdf
    result = Accounting::Tripletex::Client.new.get_file("invoice/#{@id}/pdf")
    file = Tempfile.new(['invoice', '.pdf'], encoding: 'ascii-8bit')
    file.write(result)
    file.rewind
    file
  end

  def serialize
    {
      :number          => @order_number,
      :reference       => @reference,
      :receiverEmail   => @customer.email,
      :orderDate       => @date,
      :invoiceComment  => @note,
      :deliveryDate    => @date,
      :customer        => { id: @customer&.id },
      :attn            => { id: attention&.id },
      :deliveryAddress => delivery_address
    }
  end

  def attention
    return nil if @attention.blank?
    @_attention ||= Accounting::Tripletex::Contact.create!(name: @attention)
  end

  def invoice_date
    DateTime.now.strftime('%Y-%m-%d')
  end

  def delivery_address
    {
      addressLine1: @delivery_name,
      addressLine2: @delivery_address,
      postalCode: @delivery_zip_acode,
      city: @delivery_city,
    }
  end

  def paid_amount
    @total_amount if @is_paid
  end

  def payment_type_id
    {
      'credit_card' => 2807258,
      'mobilepay' => 2807258
    }[@payment_type]
  end

end
