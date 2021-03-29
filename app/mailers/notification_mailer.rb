class NotificationMailer < ApplicationMailer

  def notify(message)
    @message = message
    mail to: 'info@eanatomi.dk', subject: message
  end
end
