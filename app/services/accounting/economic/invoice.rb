class Accounting::Economic::Invoice < Accounting::Base::Invoice

  # required: currency, date, customer.customerNumber, layout.layoutNumber, paymentTerms.paymentTermsNumber, recipient.name, recipient.vatZone
  def serialize
    {
      currency: currency.upcase,
      date: DateTime.now.to_date.to_s,
      delivery: {
        address: delivery_name_att_address,
        city: delivery_city.to_s,
        country: delivery_country.to_s,
        zip: delivery_zip.to_s
      },
      lines: items.map(&:serialize),
      customer: {
        customerNumber: customer.id
      },
      layout: {
        layoutNumber: layout_id
      },
      paymentTerms: {
        paymentTermsNumber: payment_terms_id
      },
      recipient: {
        name: recipient_name,
        # ean: customer_ean_number,
        address: customer.address.to_s,
        city: customer.city.to_s,
        country: customer.country.to_s,
        zip: customer.zip.to_s,
        vatZone: {
          vatZoneNumber: customer.vat_zone_id
        }
      },
      references: {
        other: reference.to_s
      },
      notes: {
        heading: heading.to_s,
        textLine1: note.to_s,
        textLine2: note2.to_s
      }
    }
  end

  def save!
    response = Accounting::Economic::Client.new.post('invoices/drafts', self.serialize)
    @id = response.body['draftInvoiceNumber']
    self
  end

  def book!
    response = Accounting::Economic::Client.new.post('invoices/booked', { draftInvoice: { draftInvoiceNumber: @id.to_i } })
    @id = response.body['bookedInvoiceNumber']
    self
  end

  def invoice_pdf
    response = Accounting::Economic::Client.new.get_raw("invoices/booked/#{@id}/pdf")

    file = Tempfile.new ['invoice', '.pdf'], encoding: 'ascii-8bit'
    file.write(response)
    file.rewind
    file
  end

  private

    def delivery_name_att_address
      att = "Att.: #{delivery_attention}" if delivery_attention.present?
      [delivery_name, att, delivery_address].select(&:present?).join("\n")
    end

    def customer_ean_number
      # if ean_number.to_s.size == 13
      #   ean_number
      # else
      #   ''
      # end
    end

    def note2
      "EAN: #{ean_number}" if ean_number.present?
    end


    def market
      Market.fetch(@market)
    end


    def recipient_name
      attention.blank? ? customer.name : "#{customer.name} (#{attention})"
    end

    def payment_terms_id
      return 2 if Rails.env.development?

      @payment_terms_id || {
        :dk => {
          'credit_card' => 26,
          'mobilepay'   => 26,
          'invoice'     => 1,
          'ean_invoice' => 24
        },
        :se => {
          'credit_card' => 26,
          'invoice'     => 21,
          'vat_invoice' => 21,
          'klarna'      => 27
        },
        :no => {
          'credit_card' => 26,
          'invoice'     => 4
        },
        :gl => {
          'credit_card' => 26,
          'invoice'     => 4
        },
        :fi => {
          'credit_card' => 26,
          'invoice'     => 4
        }
      }.fetch(market.key).fetch(payment_type)
    end

    def layout_id
      return 19 if Rails.env.development?

      @layout_id || {
        :dk => {
          'credit_card' => 16,
          'mobilepay'   => 16,
          'invoice'     => 15,
          'ean_invoice' => 15
        },
        :se => {
          'credit_card' => 16,
          'klarna'      => 16,
          'invoice'     => 36,
          'vat_invoice' => 36
        },
        :no => {
          'credit_card' => 16,
          'invoice'     => 45
        },
        :gl => {
          'credit_card' => 16,
          'invoice'     => 17
        },
        :fi => {
          'credit_card' => 16,
          'invoice'     => 17
        }
      }.fetch(market.key).fetch(payment_type)
    end

end
