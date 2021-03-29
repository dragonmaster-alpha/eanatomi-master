class OrderWaitingJob < ApplicationJob
  queue_as :default

  def perform(order)
    if order.received? && order.out_of_stock?
      case order.waiting_notice.to_i
      when 0
        first_notice(order)
      when 1
        second_notice(order)
      when 2
        third_notice(order)
      end
    end
  end

  private

    def first_notice(order)
      order.update waiting_notice: 1
      order.log!('Sent first waiting notice')
      OrderMailer.first_waiting_notice(order).deliver_now
      OrderWaitingJob.set(wait: 1.week).perform_later(order)
    end

    def second_notice(order)
      order.update waiting_notice: 2
      order.log!('Sent second waiting notice')
      OrderMailer.second_waiting_notice(order).deliver_now
      OrderWaitingJob.set(wait: 1.week).perform_later(order)
    end

    def third_notice(order)
      order.update waiting_notice: 3
      order.log!('Sent third waiting notice')
      OrderMailer.third_waiting_notice(order).deliver_now
    end
end
