# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/enquiry
  def enquiry
    UserMailer.enquiry(Enquiry.last)
  end

end
