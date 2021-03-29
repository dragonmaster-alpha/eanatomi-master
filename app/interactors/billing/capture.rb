class Billing::Capture
  include Interactor

  def call
    capture if authorized?
  end

  private

    def capture
      begin
        Billing.new(context.order).capture
        context.order.log!('Payment captured')
      rescue Billing::CaptureError => e
        if e.message.include?('ePay: -1023')
          # Payment is already captured
          context.order.payment.captured!
        else
          raise e
        end
      end

      context.order.log!('Payment captured')
    end

    def authorized?
      context.order&.payment.authorized?
    end

end
