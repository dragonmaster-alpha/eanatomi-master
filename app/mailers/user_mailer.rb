class UserMailer < ApplicationMailer

  def enquiry(enquiry)
    @enquiry = enquiry

    mail to: "info@eanatomi.dk", subject: "Henvendelse fra #{@enquiry.name}", reply_to: @enquiry.email
  end
end
